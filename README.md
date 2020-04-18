# jdkswap
Simple script to swap JDK installations.

## Limitations

* Currently only supports **bash**.

## Setup 

1. Download the script:

   ```
   $ git clone git@github.com:mepcotterell/jdkswap.git
   ```
   
2. Create a `~/.jdkswap` configuration file. Here is an example:

   ```
   declare -A JDKSWAP_JDKS=(
       ["oracle:jdk-8.0.251"]="/path/to/oracle/jdk1.8.0_251"
       ["oracle:jdk-14.0.1"]="/path/to/oracle/jdk-14.0.1"
       ["openjdk:jdk-11.0.2"]="/path/to/openjdk/jdk-11.0.2"
   )

   JDKSWAP_DEFAULT_JDK="oracle:jdk-8.0.251"
   ```
   
3. Install the default JDK:

   ```
   $ ./jdkswap --install
   ```
   
## Usage
