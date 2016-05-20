class ansible::user (
  Variant[Boolean,String] $ensure           = present,
  String                  $password         = '',
  Boolean                 $configure_sudo   = true,
  Boolean                 $run_ssh_keygen   = false,
) {

  user { 'ansible':
    ensure     => $ensure,
    comment    => 'ansible',
    managehome => true,
    shell      => '/bin/bash',
    home       => '/home/ansible',
    password   => $password,
  }

  $dir_ensure = ::tp::ensure2dir($ensure)

  file { '/home/ansible/.ssh' :
    ensure  => $dir_ensure,
    mode    => '0700',
    owner   => 'ansible',
    group   => 'ansible',
    require => User[ansible],
  }

  if $run_ssh_keygen {
    exec { 'home_ansible_ssh_keygen':
      path    => ['/usr/bin'],
      command => 'ssh-keygen -t rsa -q -f /home/ansible/.ssh/id_rsa -N ""',
      creates => '/home/ansible/.ssh/id_rsa',
      user    => 'ansible',
      require => File['/home/ansible/.ssh'],
    }
  }

  if $configure_sudo {
    file { '/etc/sudoers.d/ansible' :
      ensure  => file,
      mode    => '0440',
      owner   => 'root',
      group   => 'root',
      content => 'ansible ALL = NOPASSWD : ALL',
    }
  }

}
