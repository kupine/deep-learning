
GENESIS_REMOTE="https://github.com/open-power-ref-design/cluster-genesis.git"
GENESIS_LOCAL="cluster-genesis"
GENESIS_COMMIT="607c6fab16822ed32cf3dc92e1781ac9faec50cb" #release v1.0
GENESIS_VERSION="1.0"
GENESIS_FULL=$(pwd)/$GENESIS_LOCAL

POWERAI_HOME=$(pwd)

PACKAGE_DIR="playbooks/packages"

DKMS_LOCATION="http://mirrors.kernel.org/ubuntu/pool/main/d/dkms/dkms_2.2.0.3-2ubuntu11_all.deb"
DKMS_FILE=${PACKAGE_DIR}/dkms.deb

CUDA_REPO="https://developer.nvidia.com/compute/cuda/8.0/prod/local_installers/cuda-repo-ubuntu1604-8-0-local_8.0.44-1_ppc64el-deb"
CUDA_FILE=${PACKAGE_DIR}/cuda8.deb

CUDNN5_REMOTE="/home/dllehr/dist_debs/libcudnn5_5.1.5-1+cuda8.0_ppc64el.deb"
CUDNN5_DEV_REMOTE="/home/dllehr/dist_debs/libcudnn5-dev_5.1.5-1+cuda8.0_ppc64el.deb"
CUDNN5_FILE=${PACKAGE_DIR}/cudnn5.deb
CUDNN5_DEV_FILE=${PACKAGE_DIR}/cudnn5_dev.deb

MLDL_REPO="https://download.boulder.ibm.com/ibmdl/pub/software/server/mldl/mldl-repo-local_1-3ibm7_ppc64el.deb"
MLDL_FILE=${PACKAGE_DIR}/mldl.deb

PACKAGE_DIR="playbooks/packages"

DYNAMIC_INVENTORY=$GENESIS_FULL/"scripts/python/yggdrasil/inventory.py"

ACTIVATE_FILE=".activate"

#sudo apt-get install aptitude

#pull cluster-genesis into project directory
./setup_git_repo.sh "${GENESIS_REMOTE}" "${GENESIS_LOCAL}" "${GENESIS_COMMIT}"

#apply any patches to genesis.
./patch_source.sh "${GENESIS_LOCAL}"

#sed -i /sources.list/s/^/#/ ${GENESIS_LOCAL}/os_images/config/*.seed

mkdir -p ${PACKAGE_DIR}


#Download Cuda Repo
if [ ! -f ${CUDA_FILE} ];
then
        echo "Downloading Cuda repository"
	wget  ${CUDA_REPO} -O ${CUDA_FILE}
else
	echo "SKIPPING: Cuda repo already downloaded"
fi
if [ ! -f ${DKMS_FILE} ];
then
        echo "Downloading dkms package"
	wget  ${DKMS_LOCATION} -O ${DKMS_FILE}
else
	echo "SKIPPING: dkms package already downloaded"
fi
if [ ! -f ${MLDL_FILE} ];
then
        echo "Downloading mldl repo"
	wget  ${MLDL_REPO} -O ${MLDL_FILE}
else
	echo "SKIPPING: mldl repo already downloaded"
fi


cp ${CUDNN5_REMOTE} ${CUDNN5_FILE}
cp ${CUDNN5_DEV_REMOTE} ${CUDNN5_DEV_FILE}


#call cluster genesis install script
cd ${GENESIS_LOCAL}
scripts/install.sh
cd ..
#export DYNAMIC_INVENTORY
#echo "DYNAMIC " $DYNAMIC_INVENTORY
#
# Move variables to activate file to be sourced by deploy.sh
# This allows us to not require the user to export the variables
# manually, and can be run in a separate environment than the
# install.sh script.
#
echo 'DYNAMIC_INVENTORY='$DYNAMIC_INVENTORY > ${ACTIVATE_FILE}
echo 'GENESIS_FULL='$GENESIS_FULL >> ${ACTIVATE_FILE}
echo 'POWERAI_HOME='$POWERAI_HOME >> ${ACTIVATE_FILE}