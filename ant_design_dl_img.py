import json
import re
import shutil
import sys
from pathlib import Path

import requests

if len(sys.argv) == 2:
    ANTD_COMPONENTS = Path("./ant-design/components")
else:
    ANTD_COMPONENTS = Path(".")

out = Path(r"antd_images")
out_images = out.joinpath("images")
if out.exists():
    shutil.rmtree(out)
out.mkdir(exist_ok=True)
out_images.mkdir(exist_ok=True)

mappings = {}


def dl(in_path, out_path):
    rep = requests.get(in_path)
    f_out = out_images.joinpath(out_path)
    f_out.write_bytes(rep.content)
    mappings[in_path] = f_out.name


def main():
    for d in ANTD_COMPONENTS.glob("*"):
        f = d.joinpath("index.en-US.md")
        if not f.exists():
            print("no exists", "/".join(f.parts[-3:]))
            continue
        content = f.read_text(encoding="utf-8")
        if "cover" in content:
            url = re.search(r"cover: (https://.*)\n", content)
            if url:
                # print(url.group(1))
                dl(url.group(1), f.parent.name.lower() + ".svg")
            else:
                print("no match", d.name)
        else:
            print("no cover", d.name)

    dl("https://gw.alipayobjects.com/zos/antfincdn/Z5c7kzvi30/expand.svg", "expand.svg")
    dl("https://gw.alipayobjects.com/zos/antfincdn/4zAaozCvUH/unexpand.svg", "unexpand.svg")
    dl("https://gw.alipayobjects.com/zos/rmsportal/KDpgvguMpGfqaHPjicRK.svg", "logo.svg")

    out.joinpath("mappings.json").write_text(json.dumps(mappings, indent=4))

    repl = r'\*'

    Path("seds.sh").write_text(
        "#!/usr/bin/env bash\n\n" +
        '\n'.join(f"sed -i 's^{k.replace('*', repl)}^{v}^g' $1" for k, v in mappings.items())
    )


if __name__ == "__main__":
    main()
