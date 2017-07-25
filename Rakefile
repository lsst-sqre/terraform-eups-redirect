require 'rake/clean'

EYAML_FILES = FileList['kubernetes/**/*.eyaml']
CLEAN.include(EYAML_FILES.ext('.yaml'))

rule '.yaml' => '.eyaml' do |t|
  puts "#{t.name} #{t.source}"
  sh "eyaml decrypt -f #{t.source} > #{t.name}"
end

def gcloud_disk_size
  # in GiB
  '4048'
end

def sh_quiet(script)
  sh script do |ok, res|
    unless ok
      # exit without verbose rake error message
      exit res.exitstatus
    end
  end
end

def tf_cmd(deploy, name, arg)
  task name do
    sh_quiet <<-EOS
      cd terraform/#{deploy}
      ../bin/terraform get
      ../bin/terraform #{arg}
    EOS
  end
end

def tf_bucket_region
  "us-west-2"
end

def env_prefix
  env = ENV['TF_VAR_env_name']

  if env.nil?
    abort('env var TF_VAR_env_name must be defined')
  end

  if env == 'prod'
    env = 'eups-redirect'
  else
    env = "#{env}-eups-redirect"
  end

  env
end

def tf_bucket
  "#{env_prefix}.lsst.codes-tf"
end

def tf_remote(deploy)
  desc 'configure remote state'

  task 'remote' do
    remote = 'init' +
      " -backend=true" +
      " -backend-config=\"region=#{tf_bucket_region}\"" +
      " -backend-config=\"bucket=#{tf_bucket}\"" +
      " -backend-config=\"key=#{deploy}/terraform.tfstate\"" +
      " -input=false" +
      " -get=true"

      sh_quiet <<-EOS
        cd terraform/#{deploy}
        ../bin/terraform #{remote}
      EOS
    end
end

namespace :eyaml do
  desc 'generate new eyaml keys'
  task :createkeys do |t|
    sh_quiet "eyaml #{t}"
  end

  desc 'setup default sqre keyring'
  task :sqre do |t|
    sh_quiet <<-EOS
      mkdir -p .lsst-certs
      cd .lsst-certs
      git init
      git remote add origin ~/Dropbox/lsst-sqre/git/lsst-certs.git
      git config core.sparseCheckout true
      echo "eyaml-keys/" >> .git/info/sparse-checkout
      git pull --depth=1 origin master
      cd ..
      ln -sf .lsst-certs/eyaml-keys keys
    EOS
  end

  desc 'decrypt all eyaml files (*.eyaml -> *.yaml'
  task :decrypt => EYAML_FILES.ext('.yaml')

  desc 'edit .eyaml file (requires keys)'
  task :edit, [:file] do |t, args|
    sh "eyaml edit #{args[:file]}"
    Rake::Task['eyaml:decrypt'].invoke
  end
end

namespace :terraform do
  namespace :bucket do
    desc 'create s3 bucket to hold remote state'
    task :create do
     sh_quiet "aws s3 mb s3://#{tf_bucket} --region #{tf_bucket_region}"
    end
  end

  desc 'download terraform'
  task :install do
    sh_quiet <<-EOS
      cd terraform
      make
    EOS
  end

  desc 'configure remote state on s3 bucket'
  task :remote => [
    'terraform:bucket:create',
    'terraform:dns:remote',
  ]

  namespace :dns do
    deploy = 'dns'

    desc 'apply'
    tf_cmd(deploy, :apply, 'apply')
    desc 'destroy'
    tf_cmd(deploy, :destroy, 'destroy -force')
    tf_remote(deploy)
  end # :dns
end

def khelper_cmd(arg)
  task arg.to_sym do
    sh_quiet <<-EOS
      cd kubernetes
      ./khelper #{arg}
    EOS
  end
end

namespace :khelper do
  desc 'create kubeneretes resources'
  khelper_cmd 'create'

  desc 'apply kubeneretes resources'
  khelper_cmd 'apply'

  desc 'write service_ip.txt'
  khelper_cmd 'ip'

  desc 'delete kubernetes resources'
  khelper_cmd 'delete'
end

def tf_output(path)
  output = nil
  Dir.chdir(path) do
    output = JSON.parse(`../bin/terraform output -json`)
  end
  output
end

desc 'write creds.sh'
task :creds do
  File.write('creds.sh', <<-EOS.gsub(/^\s+/, '')
    export AWS_ACCESS_KEY_ID=#{ENV['AWS_ACCESS_KEY_ID']}
    export AWS_SECRET_ACCESS_KEY=#{ENV['AWS_SECRET_ACCESS_KEY']}
    export AWS_DEFAULT_REGION=us-east-1
    export TF_VAR_aws_access_key=$AWS_ACCESS_KEY_ID
    export TF_VAR_aws_secret_key=$AWS_SECRET_ACCESS_KEY
    export TF_VAR_aws_default_region=$AWS_DEFAULT_REGION
    export TF_VAR_env_name=#{ENV['USER']}-dev
    EOS
  )
end

task :default => [
  'terraform:install',
  'eyaml:decrypt',
]

desc 'destroy all tf/kube resources'
task :destroy => [
  'khelper:delete',
  'terraform:dns:destroy',
]
