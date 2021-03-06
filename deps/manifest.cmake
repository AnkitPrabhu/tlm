#
# Keep the list sorted alphabetically, and the platforms alphabetically.
# The syntax is:
#
# DECLARE_DEP (name VERSION version-revision PLATFORMS platform1 platform2)
#
# This manifest contains entries for SUPPORTED platforms. These are
# platforms on which Couchbase builds and delivers Server binaries
# to customers.
#
# The list of supported platforms may change between releases, but
# you may use the cmake macro CB_GET_SUPPORTED_PLATFORM to
# check if this is a supported platform.
#
DECLARE_DEP (breakpad V2 VERSION 0.1.0 BUILD 4 PLATFORMS amzn2 centos7 debian8 debian9 suse12 suse15 ubuntu16.04 ubuntu18.04 windows_msvc2017)
DECLARE_DEP (breakpad V2 VERSION 0.1.0 BUILD 6 PLATFORMS rhel8)
DECLARE_DEP (boost VERSION 1.67.0-cb4 PLATFORMS amzn2 centos7 debian8 debian9 macosx suse12 suse15 ubuntu16.04 ubuntu18.04 windows_msvc2017)
DECLARE_DEP (boost VERSION 1.67.0-cb6 PLATFORMS rhel8)
# curl 7.60.0-cb1 debian7 suse11
DECLARE_DEP (curl VERSION 7.60.0-cb1 PLATFORMS debian7 suse11)
DECLARE_DEP (curl VERSION 7.61.1-cb2 PLATFORMS centos6 ubuntu14.04 windows_msvc2015)
DECLARE_DEP (curl V2 VERSION 7.64.0 BUILD 9 PLATFORMS amzn2 centos7 debian8 debian9 macosx suse12 suse15 ubuntu16.04 ubuntu18.04 windows_msvc2017)
DECLARE_DEP (curl V2 VERSION 7.64.0 BUILD 10 PLATFORMS rhel8)
DECLARE_DEP (double-conversion VERSION 3.0.0-cb2 PLATFORMS amzn2 centos6 centos7 debian8 debian9 macosx suse12 suse15 ubuntu16.04 ubuntu18.04 windows_msvc2015 windows_msvc2017)
DECLARE_DEP (double-conversion VERSION 3.0.0-cb4 PLATFORMS rhel8)
DECLARE_DEP (erlang VERSION OTP-20.3.8.11-cb6 PLATFORMS amzn2 centos7 debian8 debian9 macosx suse12 suse15 ubuntu16.04 ubuntu18.04 windows_msvc2017)
DECLARE_DEP (erlang VERSION OTP-20.3.8.11-cb7 PLATFORMS rhel8)
DECLARE_DEP (flatbuffers VERSION 1.10.0-cb2 PLATFORMS centos6 centos7 debian7 debian8 debian9 macosx suse11 suse12 ubuntu14.04 ubuntu16.04 windows_msvc2015 windows_msvc2017 amzn2 suse15 ubuntu18.04)
DECLARE_DEP (flatbuffers VERSION 1.10.0-cb4 PLATFORMS rhel8)
DECLARE_DEP (flex VERSION 2.5.4a-cb1 PLATFORMS windows_msvc2015 windows_msvc2017)
DECLARE_DEP (flex VERSION 2.6.4-cb4 PLATFORMS amzn2 centos6 centos7 debian8 debian9 macosx suse11 suse12 suse15 ubuntu14.04 ubuntu16.04 ubuntu18.04)
DECLARE_DEP (flex VERSION 2.6.4-cb6 PLATFORMS rhel8)
DECLARE_DEP (folly VERSION v2019.04.01.00-cb1 PLATFORMS amzn2 centos7 debian8 debian9 macosx suse12 suse15 ubuntu16.04 ubuntu18.04 windows_msvc2017)
DECLARE_DEP (folly VERSION v2019.04.01.00-cb3 PLATFORMS rhel8)
## Define folly's gflag dependency for Escrow build purpose, gflag is not required in Server's build
DECLARE_DEP (gflags VERSION 2.2.1-cb2 PLATFORMS amzn2 centos6 centos7 debian8 debian9 macosx suse12 suse15 ubuntu16.04 ubuntu18.04 windows_msvc2015 windows_msvc2017 SKIP)
DECLARE_DEP (gflags VERSION 2.2.1-cb4 PLATFORMS rhel8)
DECLARE_DEP (glog VERSION 0.3.5-cb1 PLATFORMS amzn2 centos6 centos7 debian8 debian9 macosx suse12 suse15 ubuntu16.04 ubuntu18.04 windows_msvc2015 windows_msvc2017)
DECLARE_DEP (glog VERSION 0.3.5-cb3 PLATFORMS rhel8)
DECLARE_DEP (grpc VERSION 1.12.0-cb2 PLATFORMS amzn2 centos7 debian8 debian9 macosx suse12 suse15 ubuntu16.04 ubuntu18.04 windows_msvc2017)
DECLARE_DEP (grpc VERSION 1.12.0-cb3 PLATFORMS rhel8)
DECLARE_DEP (jemalloc VERSION 5.1.0-cb4 PLATFORMS amzn2 centos7 debian7 debian8 debian9 macosx suse12 suse15 ubuntu16.04 ubuntu18.04 windows_msvc2017)
DECLARE_DEP (jemalloc VERSION 5.1.0-cb6 PLATFORMS rhel8)
DECLARE_DEP (json VERSION 3.5.0-cb1 PLATFORMS amzn2 centos7 debian8 debian9 macosx suse12 suse15 ubuntu16.04 ubuntu18.04 windows_msvc2017)
DECLARE_DEP (json VERSION 3.5.0-cb2 PLATFORMS rhel8)
DECLARE_DEP (libevent VERSION 2.1.8-cb8 PLATFORMS amzn2 centos7 debian8 debian9 macosx suse12 suse15 ubuntu16.04 ubuntu18.04 windows_msvc2017)
DECLARE_DEP (libevent VERSION 2.1.8-cb10 PLATFORMS rhel8)
DECLARE_DEP (libuv VERSION 1.20.3-cb1 PLATFORMS centos6 debian7 suse11 ubuntu14.04 windows_msvc2015)
DECLARE_DEP (libuv V2 VERSION 1.20.3 BUILD 17 PLATFORMS amzn2 centos7 debian8 debian9 macosx suse12 suse15 ubuntu16.04 ubuntu18.04 windows_msvc2017)
DECLARE_DEP (libuv V2 VERSION 1.20.3 BUILD 19 PLATFORMS rhel8)
DECLARE_DEP (lz4 VERSION 1.8.0-cb2 PLATFORMS amzn2 centos6 centos7 debian8 debian9 macosx suse11 suse12 suse15 ubuntu14.04 ubuntu16.04 ubuntu18.04)
DECLARE_DEP (lz4 VERSION 1.8.0-cb4 PLATFORMS rhel8)
DECLARE_DEP (maven VERSION 3.5.2-cb5 PLATFORMS amzn2 centos6 centos7 debian8 debian9 macosx suse11 suse12 suse15 ubuntu14.04 ubuntu16.04 ubuntu18.04 windows_msvc2015 windows_msvc2017)
DECLARE_DEP (maven VERSION 3.5.2-cb6 PLATFORMS rhel8)
DECLARE_DEP (numactl VERSION 2.0.11-cb1 PLATFORMS amzn2 centos6 centos7 debian7 debian8 debian9 suse11 suse12 suse15 ubuntu14.04 ubuntu16.04 ubuntu18.04)
DECLARE_DEP (numactl VERSION 2.0.11-cb3 PLATFORMS rhel8)
DECLARE_DEP (openjdk-rt VERSION 1.8.0.171-cb1 PLATFORMS amzn2 centos6 centos7 debian8 debian9 macosx suse11 suse12 suse15 ubuntu14.04 ubuntu16.04 ubuntu18.04 windows_msvc2015 windows_msvc2017)
DECLARE_DEP (openjdk-rt VERSION 1.8.0.171-cb2 PLATFORMS rhel8)
DECLARE_DEP (openssl VERSION 1.1.1b-cb3 PLATFORMS amzn2 centos7 debian8 debian9 macosx suse12 suse15 ubuntu16.04 ubuntu18.04 windows_msvc2017)
DECLARE_DEP (openssl VERSION 1.1.1b-cb4 PLATFORMS rhel8)
DECLARE_DEP (opentracing-cpp VERSION v1.5.1-cb1 PLATFORMS amzn2 centos7 debian8 debian9 macosx suse11 suse12 ubuntu16.04 ubuntu18.04)
DECLARE_DEP (opentracing-cpp VERSION v1.5.1-cb2 PLATFORMS windows_msvc2017)
DECLARE_DEP (opentracing-cpp VERSION v1.5.1-cb4 PLATFORMS rhel8)
DECLARE_DEP (pcre VERSION 8.42-cb3 PLATFORMS amzn2 centos7 debian8 debian9 macosx suse12 suse15 ubuntu16.04 ubuntu18.04 windows_msvc2017)
DECLARE_DEP (pcre VERSION 8.42-cb5 PLATFORMS rhel8)
DECLARE_DEP (protoc-gen-go V2 VERSION 1.3.0 BUILD 5 PLATFORMS amzn2 centos7 debian8 debian9 macosx suse12 suse15 ubuntu16.04 ubuntu18.04 windows_msvc2017)
DECLARE_DEP (protoc-gen-go V2 VERSION 1.3.0 BUILD 7 PLATFORMS rhel8)
DECLARE_DEP (rocksdb VERSION 5.18.3-cb2 PLATFORMS amzn2 centos6 centos7 debian8 debian9 macosx suse11 suse12 suse15 ubuntu14.04 ubuntu16.04 ubuntu18.04)
DECLARE_DEP (rocksdb VERSION 5.18.3-cb4 PLATFORMS rhel8)
DECLARE_DEP (snappy VERSION 1.1.1 PLATFORMS windows_msvc2015 windows_msvc2017)
DECLARE_DEP (snappy VERSION 1.1.1-cb3 PLATFORMS amzn2 centos6 centos7 debian8 debian9 macosx suse11 suse12 suse15 ubuntu14.04 ubuntu16.04 ubuntu18.04)
DECLARE_DEP (snappy VERSION 1.1.1-cb4 PLATFORMS rhel8)
DECLARE_DEP (v8 VERSION 7.1-cb5 PLATFORMS amzn2 centos7 debian8 debian9 macosx suse12 suse15 ubuntu16.04 ubuntu18.04)
DECLARE_DEP (v8 VERSION 7.1-cb1 PLATFORMS windows_msvc2017)
DECLARE_DEP (zlib VERSION 1.2.11-cb3 PLATFORMS centos6 suse11 ubuntu14.04 windows_msvc2015)
DECLARE_DEP (zlib V2 VERSION 1.2.11 BUILD 4 PLATFORMS amzn2 centos7 debian8 debian9 macosx suse12 suse15 ubuntu16.04 ubuntu18.04 windows_msvc2017)
DECLARE_DEP (zlib V2 VERSION 1.2.11 BUILD 6 PLATFORMS rhel8)
