#!/usr/bin/env bash
# shellcheck disable=SC2164

if ! [ -x "$(command -v git)" ]; then
  echo 'Error: git is not installed.' >&2
  exit 1
fi

git clone https://github.com/ant-design/ant-design.git

python ant_design_dl_img.py ant-design/components
chmod +x seds.sh

cd ant-design
git checkout gh-pages

grep -HEorna "https.*huamei.*img/.{32}" components/ | cut -f1 -d: >> files_to_sed
grep -HEorna "https.*cRK" ./ | cut -f1 -d: >> files_to_sed

echo "Len files_to_sed $(wc -l files_to_sed)"

cat files_to_sed | xargs -iZ ../seds.sh Z

cd ..

cp antd_images/images/* ant-design/

zip_name="ant_design_site_$(date "+%H%M%S_%d%m%Y").zip"

echo "Save as $zip_name"

zip -r $zip_name ant-design/

rm -rf ant-design