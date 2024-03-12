#!/bin/sh
name=A_$1
key=$2
secret=$3
proxy=$4

if [ -f "$name.js" ]; then
  echo "文件已存在,如需重新生成，请删除当前文件：rm -rf ./$name.js && rm -rf ./script/$name.sh"
  exit 0 
fi

mkdir -pv ./script
cp -r ./index.js $name.js
sed -i "s#bk#$key#" $name.js
sed -i "s#bs#$secret#" $name.js
echo "已生成$name.js文件，开始生成$name.sh"
if [ -f "./script/$name.sh" ]; then
  echo "文件已存在,如需重新生成，请删除当前文件：rm -rf ./$name.js && rm -rf ./script/$name.sh"
  exit 0 
fi

if [ "x$proxy" = "x" ];then
cat >./script/$name.sh<<EOF
#!/bin/bash
curl cip.cc
node ../$name.js
EOF
else
cat >./script/$name.sh<<EOF
#!/bin/bash
export http_proxy=$proxy
export https_proxy=$proxy
curl cip.cc
node ../$name.js
EOF
fi
chmod +x ./script/$name.sh
