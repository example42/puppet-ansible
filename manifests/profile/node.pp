class ansible::profile::node (

  Variant[Boolean,String] $ensure          = present,

) {

  include ::ansible

  if $::ansible::keyshare_method == 'storeconfig' {
    @@sshkey { "ansible_${::fqdn}_rsa":
      ensure       => $ensure,
      host_aliases => [ $::fqdn, $::hostname, $::ipaddress ],
      type         => 'ssh-rsa',
      key          => $::sshrsakey,
      tag          => "ansible_node_${::ansible::master}_rsa"
    }
    # Authorize master host ssh key for remote connection
    Ssh_authorized_key <<| tag == "ansible_master_${::ansible::master}" |>>
  }
}
