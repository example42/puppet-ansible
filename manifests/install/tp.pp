class ansible::install::tp (

  Variant[Boolean,String] $ensure           = present,
  Hash                    $confs            = { },
  Hash                    $dirs             = { },

) {

  include ::ansible
  
  tp::install { 'ansible':
    options_hash  => $::ansible::module_options,
    settings_hash => $::ansible::module_settings,
    data_module   => $::ansible::data_module,
    conf_hash     => $confs,
    dir_hash      => $dirs,
    auto_conf     => $::ansible::auto_conf,
  }

}
