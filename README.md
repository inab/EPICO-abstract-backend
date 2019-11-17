# NAME

EPICO::REST::Backend - Abstract backend class for EPICO REST API

# SYNOPSIS

```perl

    package EPICO::REST::Backend::NewBackend;
    
    use base qw(EPICO::REST::Backend);

```

# DESCRIPTION

EPICO::REST::Backend is the backbone of the pluggable backends on EPICO REST API.

It was initially  created under the umbrella of [BLUEPRINT project](https://blueprint-epigenome.eu).

# RATIONALE

Instead of having a monolithic API, EPICO REST API was designed thinking
both on different instances of the same implementation, as well as pluggable
instances for other external sources.

# METHODS

_(to be documented)_

# INSTALLATION

Latest release of this package is available in the [BSC INB DarkPAN](https://gitlab.bsc.es/inb/darkpan/). You
can install it just using `cpanm`:

```bash

    cpanm --mirror-only --mirror https://gitlab.bsc.es/inb/darkpan/raw/master/ --mirror https://cpan.metacpan.org/ BP::DCCLoader

```

# AUTHOR

José M. Fernández [https://github.com/jmfernandez](https://github.com/jmfernandez)

# COPYRIGHT

The library was initially created several years ago for the EPICO REST
API in the [BLUEPRINT project](http://www.blueprint-epigenome.eu/).

Copyright 2019- José M. Fernández & Barcelona Supercomputing Center (BSC)

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the LGPL 2.1 terms.

# SEE ALSO
