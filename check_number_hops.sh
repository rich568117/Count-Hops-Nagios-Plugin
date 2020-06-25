# Count Hops Nagios Plugin

#!/bin/bash

helpFunction()
{
   echo ""
   echo "Usage: $0 -h parameterH -m parameterM -w parameterW -c parameterC"
   echo -e "\t-h Host to Check"
   echo -e "\t-m Max Number of Hops"
   echo -e "\t-w Warning Limit"
   echo -e "\t-c Critical Limit"
   exit 1 # Exit script after printing help
}

while getopts "h:m:w:c:" opt
do
   case "$opt" in
      h ) parameterH="$OPTARG" ;;
      m ) parameterM="$OPTARG" ;;
      w ) parameterW="$OPTARG" ;;
      c ) parameterC="$OPTARG" ;;
      ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
   esac
done

# Print helpFunction in case parameters are empty
if [ -z "$parameterH" ] || [ -z "$parameterM" ] || [ -z "$parameterW" ] || [ -z "$parameterC" ]
then
   echo "Some or all of the parameters are empty";
   helpFunction
fi

# Begin script in case all parameters are correct
numberHOPS=$(traceroute -m $parameterM -I $parameterH | awk 'END{print $1}')

if [ $numberHOPS -gt $(($parameterC - 1)) ]; then
	echo "CRITICAL - More than 8 Hops"
	exit 2
elif [ $numberHOPS -gt $(($parameterW - 1)) ]; then
	echo "WARNING - More than 7 Hops"
	exit 1
else
echo "OK - Exactly 7 Hops"
exit 0
fi