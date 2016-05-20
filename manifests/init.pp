# @class ansible
#
class ansible (

  Variant[Boolean,String] $ensure             = present,

  String                  $install_class      = '::ansible::install::tp',
  String                  $user_class         = '::ansible::user',
 
  String                  $master             = '',
  String                  $ssh_key            = '',
  Variant[Undef,String]   $keyshare_method    = '',

  Hash                    $options            = { },
  Hash                    $settings           = { },

  Boolean                 $auto_restart       = true,
  Boolean                 $auto_conf          = false,
  Boolean                 $auto_prerequisites = true,

  String[1]               $data_module        = 'ansible',

  ) {

  $tp_settings = tp_lookup('ansible','settings',$data_module,'merge')
  $module_settings = $tp_settings + $settings
  if $module_settings['service_name'] and $auto_restart {
    $service_notify = "Service[${module_settings['service_name']}]"
  } else {
    $service_notify = undef
  }
  $tp_options = tp_lookup('ansible','options',$data_module,'merge')
  $module_options = $tp_options + $options

  if ::tp::is_something($install_class) {
    contain $install_class
  }

  if ::tp::is_something($user_class) {
    contain $user_class
  }

}
