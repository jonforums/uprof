# NMAKE file for building `uprof.dll` Pintool

#### BEGIN CONFIGURATION ####

# PIN_HOME is the root directory of your Pin Kit installation
# TARGET is either 'ia32' or 'ia32e'
PIN_HOME = C:\Apps\pin
TARGET = x86

#### END CONFIGURATION ####

!if "$(TARGET)"!="x86" && "$(TARGET)"!="x86_64"
!error  NMAKE: you must define TARGET macro to be either ia32 or ia32e
!endif

!if "$(TARGET)"=="x86"
TARGET_LONG=ia32
TARGET_EXT=ia32
!elseif "$(TARGET)"=="x86_64"
TARGET_LONG=intel64
TARGET_EXT=ia32_intel64
!endif

PIN_SOURCE = $(PIN_HOME)\source
PIN_TOOLS = $(PIN_SOURCE)\tools

OBJS = uprof.obj profile.obj
BUILD_DIR = build-$(TARGET_LONG)

XEDKIT       = $(PIN_HOME)\extras\xed2-$(TARGET_LONG)
PIN_IPATHS   = /I$(PIN_HOME)\source\include /I$(PIN_HOME)\source\include\gen \
               /I$(XEDKIT)\include /I$(PIN_HOME)\extras\components\include
PIN_LPATHS   = /LIBPATH:$(PIN_HOME)\$(TARGET_LONG)\lib \
               /LIBPATH:$(PIN_HOME)\$(TARGET_LONG)\lib-ext \
               /LIBPATH:$(XEDKIT)\lib

!include $(PIN_TOOLS)\ms.flags

PIN_CXXFLAGS = $(PIN_COMMON_CXXFLAGS) $(PIN_EXTRA_CXXFLAGS)
PIN_LDFLAGS  = $(PIN_COMMON_LDFLAGS)  $(PIN_EXTRA_LDFLAGS)

!if "$(DEBUG)"=="1"
PIN_CXXFLAGS = $(PIN_CXXFLAGS) $(PIN_DEBUG_CXXFLAGS)
PIN_LDFLAGS  = $(PIN_LDFLAGS)  $(PIN_DEBUG_LDFLAGS)
!else
PIN_CXXFLAGS = $(PIN_CXXFLAGS) $(PIN_RELEASE_CXXFLAGS)
PIN_LDFLAGS  = $(PIN_LDFLAGS)  $(PIN_RELEASE_LDFLAGS)
!endif

!if "$(TARGET)"=="x86"
PIN_CXXFLAGS = $(PIN_CXXFLAGS) $(PIN_IA32_CXXFLAGS) $(PIN_EXTRA_IA32_CXXFLAGS)
PIN_LDFLAGS  = $(PIN_LDFLAGS)  $(PIN_IA32_LDFLAGS)  $(PIN_EXTRA_IA32_LDFLAGS)
PIN_LIBS     = $(PIN_COMMON_LIBS) $(PIN_IA32_LIBS)
!else
PIN_CXXFLAGS = $(PIN_CXXFLAGS) $(PIN_IA32E_CXXFLAGS) $(PIN_EXTRA_IA32E_CXXFLAGS)
PIN_LDFLAGS  = $(PIN_LDFLAGS)  $(PIN_IA32E_LDFLAGS)  $(PIN_EXTRA_IA32E_LDFLAGS)
PIN_LIBS     = $(PIN_COMMON_LIBS) $(PIN_IA32E_LIBS)
!endif

# final build flags
PIN_CXXFLAGS = $(PIN_CXXFLAGS) $(PIN_IPATHS)
PIN_LDFLAGS  = $(PIN_LDFLAGS)  $(PIN_LPATHS)


.SUFFIXES :
.SUFFIXES : .dll .obj .exe .cpp

all: .\$(BUILD_DIR) $(BUILD_DIR)\uprof.dll

$(BUILD_DIR)\uprof.dll: $(BUILD_DIR)\uprof.obj $(BUILD_DIR)\profile.obj

.cpp{$(BUILD_DIR)}.obj:
	$(CXX) $(PIN_CXXFLAGS) /c /Fo$@ $<

{$(BUILD_DIR)}.obj{$(BUILD_DIR)}.dll:
	$(PIN_LD) $(PIN_LDFLAGS) /IMPLIB:$*.lib /PDB:$*.pdb /OUT:$@ $? $(PIN_LIBS)

.\$(BUILD_DIR):
	md $@

clean:
	-rd /s /q $(BUILD_DIR)
