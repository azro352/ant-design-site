#!/usr/bin/env bash
# shellcheck disable=SC2164

if ! [ -x "$(command -v git)" ]; then
  echo 'Error: git is not installed.' >&2
  exit 1
fi

echo "$(date "+%H:%M:%S"): START CLONE"
git clone https://github.com/ant-design/ant-design.git
echo "$(date "+%H:%M:%S"): END CLONE"

echo "$(date "+%H:%M:%S"): START DL IMAGES"
python ant_design_dl_img.py ant-design/components
chmod +x seds.sh
echo "$(date "+%H:%M:%S"): END DL IMAGES"

cd ant-design
git checkout gh-pages

echo "$(date "+%H:%M:%S"): START DL IMAGES"
grep -HEorna "https.*huamei.*img/.{32}" components/ | cut -f1 -d: >> files_to_sed
grep -HEorna "https.*cRK" ./ | cut -f1 -d: >> files_to_sed
echo "$(date "+%H:%M:%S"): END DL IMAGES"

echo "Len files_to_sed $(wc -l files_to_sed)"

echo "$(date "+%H:%M:%S"): START SED PATHS"
grep -HEorna "huamei_7[a-zA-Z0-9/_-]+img" components | wc -l
grep -HEorna "huamei_7[a-zA-Z0-9/_-]+img.{24}" components | head
cat files_to_sed | xargs -iZ ../seds.sh Z
grep -HEorna "huamei_7[a-zA-Z0-9/_-]+img" components | wc -l
grep -HEorna "huamei_7[a-zA-Z0-9/_-]+img.{24}" components | head
echo "$(date "+%H:%M:%S"): END SED PATHS"

rm -rf .git

cd ..

cp antd_images/images/* ant-design/

zip_name="ant_design_site_$(date "+%H%M%S_%d%m%Y").zip"

echo "Save as $zip_name"

zip -r $zip_name ant-design/

rm -rf ant-design










