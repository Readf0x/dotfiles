pw=$(pw-dump | jq -r)
headphones='"alsa_output.usb-SteelSeries_Arctis_Nova_7-00.analog-stereo"'
h_id=$(echo "$pw" | jq ".[] | select(.info.props.\"node.name\" == $headphones).id")
speakers='"alsa_output.pci-0000_0a_00.6.analog-stereo"'
s_id=$(echo "$pw" | jq ".[] | select(.info.props.\"node.name\" == $speakers).id")
current=$(echo "$pw" | jq '.[] | select(.metadata).metadata.[] | select(.key == "default.audio.sink").value.name')

echo "$h_id"
echo "$s_id"
echo "$current"

if [[ $current == "$headphones" ]]; then
  wpctl set-default "$s_id"
else
  wpctl set-default "$h_id"
fi
