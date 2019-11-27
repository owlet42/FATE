########################################################
# Copyright 2019-2020 program was created VMware, Inc. #
# SPDX-License-Identifier: Apache-2.0                  #
########################################################

#!/bin/bash
set -e

BASEDIR=$(dirname "$0")
cd $BASEDIR
WORKINGDIR=`pwd`
source_code_dir=$(cd `dirname ${WORKINGDIR}`; pwd)

# fetch fate-python image
source .env
packages_dir=${source_code_dir}/cluster-deploy/packages
mkdir -p ${packages_dir}
source ../cluster-deploy/scripts/default_configurations.sh
  
buildBase() {
  echo "START BUILDING BASE IMAGE"
  [ -f ${source_code_dir}/docker-build/docker/base/pip-packages-fate-${python_version}.tar.gz ] && rm ${source_code_dir}/docker-build/docker/base/pip-packages-fate-${python_version}.tar.gz
  [ -f ${source_code_dir}/docker-build/docker/base/requirements.txt ] && rm ${source_code_dir}/docker-build/docker/base/requirements.txt
  ln ${source_code_dir}/cluster-deploy/packages/pip-packages-fate-${python_version}.tar.gz ${source_code_dir}/docker-build/docker/base/pip-packages-fate-${python_version}.tar.gz
  ln ${source_code_dir}/requirements.txt ${source_code_dir}/docker-build/docker/base/requirements.txt
  echo "START BUILDING BASE IMAGE"
  cd ${WORKINGDIR}

  docker build -f docker/base/Dockerfile -t ${PREFIX}/base-image:${BASE_TAG} ${source_code_dir}/docker-build/docker/base

  rm ${source_code_dir}/docker-build/docker/base/pip-packages-fate-${version}.tar.gz

  echo "FINISH BUILDING BASE IMAGE"
}

buildModule() {
  [ -f ${source_code_dir}/docker-build/docker/modules/federation/fate-federation-${version}.tar.gz ] && rm ${source_code_dir}/docker-build/docker/modules/federation/fate-federation-${version}.tar.gz
  [ -f ${source_code_dir}/docker-build/docker/modules/proxy/fate-proxy-${version}.tar.gz ] && rm ${source_code_dir}/docker-build/docker/modules/proxy/fate-proxy-${version}.tar.gz
  [ -f ${source_code_dir}/docker-build/docker/modules/roll/eggroll-roll-${version}.tar.gz ] && rm ${source_code_dir}/docker-build/docker/modules/roll/eggroll-roll-${version}.tar.gz
  [ -f ${source_code_dir}/docker-build/docker/modules/meta-service/eggroll-meta-service-${version}.tar.gz ] && rm ${source_code_dir}/docker-build/docker/modules/meta-service/eggroll-meta-service-${version}.tar.gz
  [ -f ${source_code_dir}/docker-build/docker/modules/fateboard/fateboard-${fateboard_version}.jar ] && rm ${source_code_dir}/docker-build/docker/modules/fateboard/fateboard-${version}.jar
  [ -f ${source_code_dir}/docker-build/docker/modules/egg/eggroll-api-${version}.tar.gz ] && rm ${source_code_dir}/docker-build/docker/modules/egg/eggroll-api-${version}.tar.gz
  [ -f ${source_code_dir}/docker-build/docker/modules/egg/eggroll-computing-${version}.tar.gz ] && rm ${source_code_dir}/docker-build/docker/modules/egg/eggroll-computing-${version}.tar.gz
  [ -f ${source_code_dir}/docker-build/docker/modules/egg/eggroll-egg-${version}.tar.gz ] && rm ${source_code_dir}/docker-build/docker/modules/egg/eggroll-egg-${version}.tar.gz
  [ -f ${source_code_dir}/docker-build/docker/modules/egg/eggroll-storage-service-cxx-${version}.tar.gz ] && rm ${source_code_dir}/docker-build/docker/modules/egg/eggroll-storage-service-cxx-${version}.tar.gz
  [ -f ${source_code_dir}/docker-build/docker/modules/egg/third_party_eggrollv1.tar.gz ] && rm ${source_code_dir}/docker-build/docker/modules/egg/third_party_eggrollv1.tar.gz
  [ -d ${source_code_dir}/docker-build/docker/modules/egg/fate_flow ] && rm -r ${source_code_dir}/docker-build/docker/modules/egg/fate_flow
  [ -d ${source_code_dir}/docker-build/docker/modules/egg/arch ] && rm -r ${source_code_dir}/docker-build/docker/modules/egg/arch
  [ -d ${source_code_dir}/docker-build/docker/modules/egg/federatedml ] && rm -r ${source_code_dir}/docker-build/docker/modules/egg/federatedml
  [ -d ${source_code_dir}/docker-build/docker/modules/python/fate_flow ] && rm -r ${source_code_dir}/docker-build/docker/modules/python/fate_flow
  [ -d ${source_code_dir}/docker-build/docker/modules/python/arch ] && rm -r ${source_code_dir}/docker-build/docker/modules/python/arch
  [ -d ${source_code_dir}/docker-build/docker/modules/python/federatedml ] && rm -r ${source_code_dir}/docker-build/docker/modules/python/federatedml
  [ -f ${source_code_dir}/docker-build/docker/modules/python/eggroll-api-${version}.tar.gz ] && rm ${source_code_dir}/docker-build/docker/modules/python/eggroll-api-${version}.tar.gz

  ln ${source_code_dir}/cluster-deploy/packages/fate-federation-${version}.tar.gz ${source_code_dir}/docker-build/docker/modules/federation/fate-federation-${version}.tar.gz
  ln ${source_code_dir}/cluster-deploy/packages/fate-proxy-${version}.tar.gz ${source_code_dir}/docker-build/docker/modules/proxy/fate-proxy-${version}.tar.gz
  ln ${source_code_dir}/cluster-deploy/packages/eggroll-roll-${version}.tar.gz ${source_code_dir}/docker-build/docker/modules/roll/eggroll-roll-${version}.tar.gz
  ln ${source_code_dir}/cluster-deploy/packages/eggroll-meta-service-${version}.tar.gz ${source_code_dir}/docker-build/docker/modules/meta-service/eggroll-meta-service-${version}.tar.gz
  ln ${source_code_dir}/cluster-deploy/packages/fateboard-${fateboard_version}.jar ${source_code_dir}/docker-build/docker/modules/fateboard/fateboard-${fateboard_version}.jar
  cp -r ${source_code_dir}/fate_flow ${source_code_dir}/docker-build/docker/modules/python/fate_flow
  cp -r ${source_code_dir}/arch ${source_code_dir}/docker-build/docker/modules/python/arch
  cp -r ${source_code_dir}/federatedml ${source_code_dir}/docker-build/docker/modules/python/federatedml
  cp -r ${source_code_dir}/examples ${source_code_dir}/docker-build/docker/modules/python/examples
  ln ${source_code_dir}/cluster-deploy/packages/eggroll-api-${version}.tar.gz ${source_code_dir}/docker-build/docker/modules/python/eggroll-api-${version}.tar.gz
  cp -r ${source_code_dir}/fate_flow ${source_code_dir}/docker-build/docker/modules/egg/fate_flow
  cp -r ${source_code_dir}/arch ${source_code_dir}/docker-build/docker/modules/egg/arch
  cp -r ${source_code_dir}/federatedml ${source_code_dir}/docker-build/docker/modules/egg/federatedml
  ln ${source_code_dir}/cluster-deploy/packages/eggroll-api-${version}.tar.gz ${source_code_dir}/docker-build/docker/modules/egg/eggroll-api-${version}.tar.gz
  ln ${source_code_dir}/cluster-deploy/packages/eggroll-computing-${version}.tar.gz ${source_code_dir}/docker-build/docker/modules/egg/eggroll-computing-${version}.tar.gz
  ln ${source_code_dir}/cluster-deploy/packages/eggroll-egg-${version}.tar.gz ${source_code_dir}/docker-build/docker/modules/egg/eggroll-egg-${version}.tar.gz
  ln ${source_code_dir}/cluster-deploy/packages/eggroll-storage-service-cxx-${version}.tar.gz ${source_code_dir}/docker-build/docker/modules/egg/eggroll-storage-service-cxx-${version}.tar.gz
  ln ${source_code_dir}/cluster-deploy/packages/third_party_eggrollv1.tar.gz ${source_code_dir}/docker-build/docker/modules/egg/third_party_eggrollv1.tar.gz

  for module in "federation" "proxy" "roll" "meta-service" "fateboard" "egg" "python"
  do
      echo "### START BUILDING ${module^^} ###"
      docker build --build-arg PREFIX=${PREFIX} --build-arg BASE_TAG=${BASE_TAG} -t ${PREFIX}/${module}:${TAG} -f ${source_code_dir}/docker-build/docker/modules/${module}/Dockerfile ${source_code_dir}/docker-build/docker/modules/${module}
      echo "### FINISH BUILDING ${module^^} ###"
      echo ""
  done;

  rm ${source_code_dir}/docker-build/docker/modules/federation/fate-federation-${version}.tar.gz
  rm ${source_code_dir}/docker-build/docker/modules/proxy/fate-proxy-${version}.tar.gz
  rm ${source_code_dir}/docker-build/docker/modules/roll/eggroll-roll-${version}.tar.gz
  rm ${source_code_dir}/docker-build/docker/modules/meta-service/eggroll-meta-service-${version}.tar.gz
  rm ${source_code_dir}/docker-build/docker/modules/fateboard/fateboard-${fateboard_version}.jar
  rm ${source_code_dir}/docker-build/docker/modules/egg/eggroll-api-${version}.tar.gz
  rm ${source_code_dir}/docker-build/docker/modules/egg/eggroll-computing-${version}.tar.gz
  rm ${source_code_dir}/docker-build/docker/modules/egg/eggroll-egg-${version}.tar.gz
  rm ${source_code_dir}/docker-build/docker/modules/egg/eggroll-storage-service-cxx-${version}.tar.gz
  rm ${source_code_dir}/docker-build/docker/modules/egg/third_party_eggrollv1.tar.gz
  rm -r ${source_code_dir}/docker-build/docker/modules/egg/fate_flow
  rm -r ${source_code_dir}/docker-build/docker/modules/egg/arch
  rm -r ${source_code_dir}/docker-build/docker/modules/egg/federatedml
  rm -r ${source_code_dir}/docker-build/docker/modules/python/fate_flow
  rm -r ${source_code_dir}/docker-build/docker/modules/python/arch
  rm -r ${source_code_dir}/docker-build/docker/modules/python/federatedml
  rm ${source_code_dir}/docker-build/docker/modules/python/eggroll-api-${version}.tar.gz
  echo ""
}

package() {
  echo "START PACKAGING"
  
  cd ${source_code_dir}
  eggroll_git_url=`grep -A 3 '"eggroll"' .gitmodules | grep 'url' | awk -F '= ' '{print $2}'`
  eggroll_git_branch=`grep -A 3 '"eggroll"' .gitmodules | grep 'branch' | awk -F '= ' '{print $2}'`
  echo "[INFO] Git clone eggroll submodule source code from ${eggroll_git_url} branch ${eggroll_git_branch}"
  if [[ -e "eggroll" ]];then
      while [[ true ]];do
          read -p "The eggroll directory already exists, delete and re-download? [y/n] " input
          case ${input} in
          [yY]*)
                  echo "[INFO] Delete the original eggroll"
                  rm -rf eggroll
                  git clone ${eggroll_git_url} -b ${eggroll_git_branch} eggroll
                  break
                  ;;
          [nN]*)
                  echo "[INFO] Use the original eggroll"
                  break
                  ;;
          *)
                  echo "Just enter y or n, please."
                  ;;
          esac
      done
  else
      git clone ${eggroll_git_url} -b ${eggroll_git_branch} eggroll
  fi

  eggroll_source_code_dir=${source_code_dir}/eggroll
  cd ${eggroll_source_code_dir}
  echo "[INFO] Compiling eggroll"
  docker run -u $(id -u):$(id -g) -v ${eggroll_source_code_dir}:/data/projects/fate/eggroll --entrypoint="" maven:3.6-jdk-8 /bin/bash -c "cd /data/projects/fate/eggroll && mvn clean package -DskipTests"
  echo "[INFO] Compile eggroll done"

  echo "[INFO] Packaging eggroll"
  cd ${eggroll_source_code_dir}
  cd api
  tar czf eggroll-api-${version}.tar.gz *
  mv eggroll-api-${version}.tar.gz ${packages_dir}/

  cd ${eggroll_source_code_dir}
  cd computing
  tar czf eggroll-computing-${version}.tar.gz *
  mv eggroll-computing-${version}.tar.gz ${packages_dir}/

  cd ${eggroll_source_code_dir}
  cd conf
  tar czf eggroll-conf-${version}.tar.gz *
  mv eggroll-conf-${version}.tar.gz ${packages_dir}/

  cd ${eggroll_source_code_dir}
  cd framework/egg/target
  tar czf eggroll-egg-${version}.tar.gz eggroll-egg-${egg_version}.jar lib/
  mv eggroll-egg-${version}.tar.gz ${packages_dir}/

  cd ${eggroll_source_code_dir}
  cd framework/meta-service/target
  tar czf eggroll-meta-service-${version}.tar.gz eggroll-meta-service-${meta_service_version}.jar lib/
  mv eggroll-meta-service-${version}.tar.gz ${packages_dir}/

  cd ${eggroll_source_code_dir}
  cd framework/roll/target
  tar czf eggroll-roll-${version}.tar.gz eggroll-roll-${roll_version}.jar lib/
  mv eggroll-roll-${version}.tar.gz ${packages_dir}/

  cd ${eggroll_source_code_dir}
  cd storage/storage-service-cxx
  tar czf eggroll-storage-service-cxx-${version}.tar.gz *
  mv eggroll-storage-service-cxx-${version}.tar.gz ${packages_dir}/
  echo "[INFO] Package eggroll done"

  cd ${source_code_dir}
  fateboard_git_url=`grep -A 3 '"fateboard"' .gitmodules | grep 'url' | awk -F '= ' '{print $2}'`
  fateboard_git_branch=`grep -A 3 '"fateboard"' .gitmodules | grep 'branch' | awk -F '= ' '{print $2}'`
  echo "[INFO] Git clone fateboard submodule source code from ${fateboard_git_url} branch ${fateboard_git_branch}"
  if [[ -e "fateboard" ]];then
      while [[ true ]];do
          read -p "The fateboard directory already exists, delete and re-download? [y/n] " input
          case ${input} in
          [yY]*)
                  echo "[INFO] Delete the original fateboard"
                  rm -rf fateboard
                  git clone ${fateboard_git_url} -b ${fateboard_git_branch} fateboard
                  break
                  ;;
          [nN]*)
                  echo "[INFO] Use the original fateboard"
                  break
                  ;;
          *)
                  echo "Just enter y or n, please."
                  ;;
          esac
      done
  else
      git clone ${fateboard_git_url} -b ${fateboard_git_branch} fateboard
  fi

  echo "[INFO] Compiling fate"
  cd ${source_code_dir}/fateboard/
  docker run -u $(id -u):$(id -g) -v ${source_code_dir}/fateboard:/data/projects/fate/fateboard --entrypoint="" maven:3.6-jdk-8 /bin/bash -c "cd /data/projects/fate/fateboard && mvn clean package -DskipTests"
  cd ${source_code_dir}/arch/
  docker run -u $(id -u):$(id -g) -v ${source_code_dir}:/data/projects/fate --entrypoint="" maven:3.6-jdk-8 /bin/bash -c "cd /data/projects/fate/arch && mvn clean package -DskipTests"
  echo "[INFO] Compile fate done"

  echo "[INFO] Packaging fate"
  cp ${source_code_dir}/fateboard/target/fateboard-${fateboard_version}.jar ${packages_dir}/

  cd ${source_code_dir}/arch/driver/federation/target
  tar czf fate-federation-${version}.tar.gz fate-federation-${federation_version}.jar lib/
  mv fate-federation-${version}.tar.gz ${packages_dir}/

  cd ${source_code_dir}/arch/networking/proxy/target
  tar czf fate-proxy-${version}.tar.gz fate-proxy-${proxy_version}.jar lib/
  mv fate-proxy-${version}.tar.gz ${packages_dir}/

  echo "[INFO] Packaging base module"
  get_module_package ${source_code_dir} "storage-service-cxx third-party" third_party_eggrollv1.tar.gz
  get_module_package ${source_code_dir} "python" pip-packages-fate-${python_version}.tar.gz
  echo "[INFO] Package base module done"
  echo "[INFO] Package fate done"
  echo "[INFO] A total of `ls ${packages_dir} | wc -l | awk '{print $1}'` packages:"
  ls -lrt ${packages_dir}
  echo "FINISH PACKAGING"
}

pushImage() {
  ## push image
  for module in "federation" "proxy" "roll" "python" "meta-service" "fateboard" "egg"
  do
      echo "### START PUSH ${module^^} ###"
      docker push ${PREFIX}/${module}:${TAG}
      echo "### FINISH PUSH ${module^^} ###"
      echo ""
  done;
}

while [ "$1" != "" ]; do
    case $1 in
         package)
                 package
                 ;;
         base)
                 buildBase
                 ;;
         modules)
                 buildModule
                 ;;
         all)
                 package
                 buildBase
                 buildModule
                 ;;
         push)
                pushImage
                ;;
    esac
    shift
done
