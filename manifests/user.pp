class ansible::user (
  Variant[Boolean,String] $ensure           = present,
  String                  $password         = '',
  Boolean                 $sudo             = true,
) {

  user { 'ansible':
    ensure     => present,
    comment    => 'ansible',
    managehome => true,
    shell      => '/bin/bash',
    home       => '/home/ansible',
    password   => $password,
  }

  file { '/home/ansible/.ssh' :
    ensure  => directory,
    mode    => '0700',
    owner   => 'ansible',
    group   => 'ansible',
    require => User[ansible],
    notify  => Exec[home_ansible_ssh_keygen]
  }

  exec { 'home_ansible_ssh_keygen':
    path    => ['/usr/bin'],
    command => 'ssh-keygen -t rsa -q -f /home/ansible/.ssh/id_rsa -N ""',
    creates => '/home/ansible/.ssh/id_rsa',
    user    => 'ansible',
  }

  if $sudo {
    file { '/etc/sudoers.d/ansible' :
      ensure  => file,
      mode    => '0440',
      owner   => 'root',
      group   => 'root',
      content => 'ansible ALL = NOPASSWD : ALL',
    }
  }

}
