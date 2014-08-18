class profiles::ntp::clock {
  class{'::ntp::clock::params':}
  ->
  class{'::ntp::clock':}
}
