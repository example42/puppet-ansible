class ansible::profile::master (

  Variant[Boolean,String] $ensure          = present,

) {

  include ::ansible

  if $::ansible::keyshare_method == 'storeconfig' and $::ansible::ssh_key {
    @@ssh_authorized_key { "ansible_user_${::ansible::common_id}_rsa":
      ensure => $ensure,
      key    => $::ansible::ssh_key,
      user   => 'ansible',
      type   => 'rsa',
      tag    => "ansible_master_${::ansible::master}"
    }
  }

  # Collect ssh host keys from nodes
  Sshkey <<| tag == "ansible_node_${::ansible::master}_rsa" |>>


}
