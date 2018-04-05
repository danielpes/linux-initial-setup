#!/bin/bash
# source (with some modifications): https://gist.github.com/TaylanTatli
# depends: jq, weather icons
dir=$(dirname "$0")
source $dir/wkey
api_key=$wkey

city_id="6452604"
unit="metric"

api="http://api.openweathermap.org/data/2.5/weather"
url="$api?id=$city_id&APPID=$api_key&units=$unit"

weather=$(curl -s $url | jq -r '. | "\(.weather[].main)"')
temp=$(curl -s $url | jq -r '. | "\(.main.temp)"')
temp=$(printf "%.0f" $temp)
icons=$(curl -s $url | jq -r '. | "\(.weather[].icon)"')

case $icons in
  01d) icon=;;
  01n) icon=;;
  02d) icon=;;
  02n) icon=;;
  03d) icon=;;
  04d) icon=;;
  09d) icon=;;
  09n) icon=;;
  10d) icon=;;
  10n) icon=;;
  11d) icon=;;
  11n) icon=;;
  13d) icon=;;
  13n) icon=;;
  50d) icon=;;
  50n) icon=;;
esac

echo $icon\ $temp"°C"
