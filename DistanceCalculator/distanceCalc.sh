#!/bin/bash
echo "Set the origin city (Tip: write City, Country for more precision)"
read origin
wget -O ./.origintext.json -q "https://api-v2.distancematrix.ai/maps/api/geocode/json?address=$origin&key=ZwdrZdC61O7hu1inldCE7wdkfUVfZIAKw3PyRtjO4xLS6Z6mtTArSiHpLsxTetGH"
origintocoordinates=$(echo $(cat .origintext.json | jq -r ".result[] | (.geometry.location.lat)"),$(cat .origintext.json | jq -r ".result[] | (.geometry.location.lng)"))

echo "Set the destination city (Tip: write City, Country for more precision)"
read destin
wget -O ./.destintext.json -q "https://api-v2.distancematrix.ai/maps/api/geocode/json?address=$destin&key=ZwdrZdC61O7hu1inldCE7wdkfUVfZIAKw3PyRtjO4xLS6Z6mtTArSiHpLsxTetGH"
destintocoordinates=$(echo $(cat .destintext.json | jq -r ".result[] | (.geometry.location.lat)"),$(cat .destintext.json | jq -r ".result[] | (.geometry.location.lng)"))

wget -O ./.distance.json -q "https://api.distancematrix.ai/maps/api/distancematrix/json?origins=$origintocoordinates&destinations=$destintocoordinates&key=uHQ09Fwvl6UIMCSta9TkPjPyeso2d674TJxIKo8HcSSOUG8Z3b64dNsEA5H28Wun"
distance=$(cat .distance.json | jq -r ".rows[].elements[].distance | (.text)" | grep -Eo "[0-9]+.[0-9]+")
if [[ -z $distance ]]
then
	echo "Can't take the distance. Can you go one to another by car?"
else
	distancemiles=$(echo "scale=2;"$distance*1.6093 | bc)
	echo "The distance between $origin and $destin is approximately $distance km or $distancemiles miles"
fi
rm -f .origintext.json
rm -f .destintext.json
rm -f .distance.json
