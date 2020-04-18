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
   $ ./jdkswap.sh --install
   ```
   
## Usage

1. Use the `--help` option to see all the options:

   ```
   $ ./jdkswap.sh --help
   ```
   
   ```
   JDKSwap 0.3 by Dr. Cotterell
   Usage: jdkswap.sh [OPTION]
   Easily swap between available JDKs.
    --help               Display this help message.
    --list               List available JDKs.
    --current            Display current JDK.
    --swapto jdkname     Swap to jdkname.
   ```
   
