#!/usr/bin/env bash
# shellcheck disable=SC2164

git clone https://github.com/ant-design/ant-design.git

python ant_design_dl_img.py ant-design/components
chmod +x seds.sh

# zip -r antd_images.zip antd_images/

cd ant-design
git checkout gh-pages

grep -HEorna "https.*huamei.*img/.{32}" components/ | cut -f1 -d: >> files_to_sed
grep -HEorna "https.*cRK" ./ | cut -f1 -d: >> files_to_sed

echo "Len files_to_sed $(wc -l files_to_sed)"

cat files_to_sed | xargs -iZ ../seds.sh Z

cd ..

zip -r ant-design-site.zip ant-design/

rm -rf ant-design