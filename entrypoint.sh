#!/bin/bash

# 检查是否提供了USER 和 PASS 环境变量
if [ -n "$USER" ] && [ -n "$PASS" ]; then
  echo "Welcome $USER"
else
  echo "Must provide USER and PASS env"
  exit 1
fi

# 检查是否提供了URL环境变量
if [ -n "$URL" ]; then
  echo "Connecting to $URL"
else
  echo "Must provide URL env"
  exit 1
fi

# 设置TUNSOCKS的默认参数，如果没有提供自定义参数则使用默认值
TUNSOCKS_ARGS=${TUNSOCKS_ARGS:="-D 0.0.0.0:1080 -H 0.0.0.0:8080"}
echo "tunsocks args: $TUNSOCKS_ARGS"

# 如果提供了OC_ARGS环境变量，则使用这些参数运行openconnect
if [ -n "$OC_ARGS" ]; then
  echo "Running oc with args $OC_ARGS"
  # 将OC_ARGS分割成数组
  ARGS=($OC_ARGS)
  # 运行openconnect，输入密码，并传入相应的参数
  echo $PASS | openconnect "${ARGS[@]}" --script-tun --script "tunsocks $TUNSOCKS_ARGS" --user $USER --passwd-on-stdin $URL
else
  # 如果没有提供OC_ARGS环境变量，则不带额外参数运行openconnect
  echo $PASS | openconnect --script-tun --script "tunsocks $TUNSOCKS_ARGS" --user $USER --passwd-on-stdin $URL
fi