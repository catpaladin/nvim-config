#!/usr/bin/env bash

fonts_dir="${HOME}/.local/share/fonts"
if [ ! -d "${fonts_dir}" ]; then
    echo "mkdir -p $fonts_dir"
    mkdir -p "${fonts_dir}"
else
    echo "Found fonts dir $fonts_dir"
fi

font=Hack
version=v2.1.0
zip=${font}.zip
curl --fail --location --show-error https://github.com/ryanoasis/nerd-fonts/releases/download/${version}/${zip} --output ${zip}
unzip -o -q -d ${fonts_dir} ${zip}
rm ${zip}

echo "fc-cache -f"
fc-cache -f
