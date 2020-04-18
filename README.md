# jdkswap

Simple script to swap between JDK installations. If users desire more options, then
they are encouraged to consider [jenv](https://github.com/jenv/jenv) as an
alternative.

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

3. Swap to the default JDK:

   ```
   $ ./jdkswap.sh --swapto
   ```

## Usage

1. Use the `--help` option to see all the options:

   ```
   $ ./jdkswap.sh --help
   ```

   ```
   jdkswap 0.3 by Dr. Cotterell
   Usage: jdkswap.sh [OPTION]
   Simple script to swap between JDK installations.
    --help               Display this help message.
    --list               List available JDKs.
    --current            Display current JDK.
    --swapto jdkname     Swap to jdkname.
   ```
