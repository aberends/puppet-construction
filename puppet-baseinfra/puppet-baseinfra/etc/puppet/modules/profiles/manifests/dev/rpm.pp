class profiles::dev::rpm {
  class{'::dev::rpm::params':}
  ->
  class{'::dev::rpm':}
}
