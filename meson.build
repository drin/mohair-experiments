# ------------------------------
# Project Definition

# >> configuration
project('duckstrait'
  ,'cpp'
  ,version         : '0.1'
  ,default_options : ['warning_level=3','cpp_std=c++17']
)


# ------------------------------
# Build variables (convenience)

# base directory
cpp_srcdir    = 'src' / 'cpp'

# dir for binary sources (1-1 with binaries)
cpp_tooldir   = cpp_srcdir / 'toolbox'

# base directory for duckdb-substrait build
user_homedir        = '/Users' / 'octalene'
duckstrait_srcdir   = user_homedir / 'code' / 'duckdb-substrait'

duckdb_incdir       = duckstrait_srcdir / 'duckdb' / 'src'   / 'include'
duckdb_builddir     = duckstrait_srcdir / 'duckdb' / 'build' / 'release' / 'src'

duckstrait_incdir   = duckstrait_srcdir / 'src'    / 'include'
duckstrait_builddir = duckstrait_srcdir / 'duckdb' / 'build' / 'release' / 'extension' / 'substrait'


# ------------------------------
# Meson dependencies (modules)

# use pkg-config to generate library build info
module_pkgcfg = import('pkgconfig')


# >> Determine the system we're building on
buildsys_type = 'unknown'

# NOTE: we do this instead of use `host_machine` to distinguish arch from ubuntu
os_name = run_command('uname', '-s', check: false).stdout().strip()
if os_name == 'Darwin'
    buildsys_type = 'macosx'

elif os_name == 'Linux'
    os_is_arch   = run_command(
      'grep', '--silent', 'NAME="Arch Linux"', '/etc/os-release', check: false
    )
    os_is_ubuntu = run_command(
      'grep', '--silent', 'NAME="Ubuntu"', '/etc/os-release', check: false
    )

    if os_is_arch.returncode() == 0
        buildsys_type = 'archlinux'

    elif os_is_ubuntu.returncode() == 0
        buildsys_type = 'ubuntu'

    endif

endif


# ------------------------------
# Library dependencies

cpp_compiler = meson.get_compiler('cpp', native: true)

# >> System-dependent dependencies

# Include directory for arrow headers
arrow_incdir = ''

# NOTE: with brew installed dependencies, macosx can resolve like archlinux
#       otherwise, macosx deps might need "manual" resolution (specific paths)
if   buildsys_type == 'macosx'
  arrow_incdir = '/opt/homebrew/include'
elif buildsys_type == 'archlinux'
endif


# >> Required dependencies

#   |> DuckDB
dep_duckdb     = cpp_compiler.find_library('duckdb', dirs: duckdb_builddir)
dep_duckstrait = cpp_compiler.find_library('substrait_extension', dirs: duckstrait_builddir)


# ------------------------------
# Binaries

# >> Executables we always create

#   |> simple cpp interface to creating a substrait blob from a query
bin_createsubstrait_srclist = [ cpp_tooldir  / 'create-substrait.cpp' ]
bin_createsubstrait = executable('create-substrait'
  ,bin_createsubstrait_srclist
  ,dependencies       : [dep_duckdb, dep_duckstrait]
  ,include_directories: [duckdb_incdir, duckstrait_incdir]
  ,install            : false
)


#   |> simple cpp interface to executing a substrait blob
bin_execsubstrait_srclist = [ cpp_tooldir  / 'exec-substrait.cpp' ]
bin_execsubstrait = executable('exec-substrait'
  ,bin_execsubstrait_srclist
  ,dependencies       : [dep_duckdb, dep_duckstrait]
  ,include_directories: [duckdb_incdir, duckstrait_incdir]
  ,install            : false
)


#   |> simple cpp interface to create substrait and then immediately translate it to duckdb
bin_explainsubstrait_srclist = [ cpp_tooldir  / 'explain-substrait.cpp' ]
bin_explainsubstrait = executable('explain-substrait'
  ,bin_explainsubstrait_srclist
  ,dependencies       : [dep_duckdb, dep_duckstrait]
  ,include_directories: [duckdb_incdir, duckstrait_incdir]
  ,install            : false
)
