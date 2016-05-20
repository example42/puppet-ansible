class ansible::install::pip (

  Variant[Boolean,String] $ensure           = present,

) {

  include ::ansible

  if $::ansible::auto_prerequisites {
    $tp_install_params = {
      before => Package['ansible'],
    }
    tp_install('python-pip',$tp_install_params)
  }

  package { 'ansible':
    ensure   => $ensure,
    provider => 'pip',
  }

}
