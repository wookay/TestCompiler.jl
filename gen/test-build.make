include sysimage.mk

gen-COMPILER_SRCS:
	@echo julia -e '"println(\"const COMPILER_SRCS = \", Vector{String}(split(replace(\"$(COMPILER_SRCS)\", \"$(JULIAHOME)/\" => \"\"))))"'

gen-COMPILER_FRONTEND_SRCS:
	@echo julia -e '"println(\"const COMPILER_FRONTEND_SRCS = \", Vector{String}(split(replace(\"$(COMPILER_FRONTEND_SRCS)\", \"$(JULIAHOME)/\" => \"\"))))"'

gen-BASE_SRCS:
	@echo julia -e '"println(\"const BASE_SRCS = \", Vector{String}(split(replace(\"$(BASE_SRCS)\", \"$(JULIAHOME)/\" => \"\"))))"'

gen-STDLIB_SRCS:
	@echo julia -e '"const VER = \"v1.14\"; println(\"const STDLIB_SRCS = replace_ver(\", Vector{String}(split(replace(\"$(STDLIB_SRCS)\", \"$(JULIAHOME)/\" => \"\", VER => \"VER\"))), \")\")"'

gen-JULIALOWERING_SRCS:
	@echo julia -e '"println(\"const JULIALOWERING_SRCS = \", Vector{String}(split(replace(\"$(JULIALOWERING_SRCS)\", \"$(JULIAHOME)/\" => \"\"))))"'
