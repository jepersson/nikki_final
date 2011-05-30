module Cartographer
  # This is where the Google Maps API key is set. Since each key works for only
  # a single URI, it will be different depending on where it's being run. That
  # is why there is a case statement. Still, within each server, each directory
  # needs its own key; for example, http://example.com/map/3 and http://example.com/map/4
  # share the same key (because it's the directory, /map/ that owns the key here
  # If your app uses a Google map on more than one action, you will need to generate several keys 
  # per server.

  # Your keys should look like:
  #  {
  #    'controller/action' = > 'BIG_LONG_KEY_GOES_HERE', 
  #    'monkey/list' => 'AAAAAAAABBBCCCCCCDEFG'
  #  }

  # Todo: determine from the actual path, rather than routing, which key to use.
  # Todo: make sure this works on windows

  GOOGLE_MAPS_API_KEYS = case `hostname`.chomp 
   when 'http://127.0.0.1:3000/'
      { 'posts' => 'ABQIAAAAHrS8wcnR09HbIogxMDbgJxR5kjZuRV-_F5NF_2paO4SKt4KSyBSRkn9qBoI-XLAUCDbD8ZgCYaplUw'}    
  end

end