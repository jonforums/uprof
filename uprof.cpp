// Copyright (c) 2011, Jon Maken
// License: 3-clause BSD
// Revision: 11/19/2011 10:32:02 AM

#include <iostream>
#include "pin.H"
using namespace std;

extern VOID function_handler(RTN, VOID*);
extern VOID app_exit_handler(INT32, VOID*);

// Command line switches
KNOB<string> ProfileOutputFile(KNOB_MODE_WRITEONCE, "pintool",
    "o", "profile_data.out", "The profile results file path and file name");

INT32 usage()
{
    cerr << "This Pintool counts the number of times a routine is executed" << endl;
    cerr << "and the number of instructions executed in a routine" << endl;
    cerr << endl << KNOB_BASE::StringKnobSummary() << endl;
    return -1;
}

int main(int argc, char **argv)
{
    PIN_InitSymbols();

    if (PIN_Init(argc, argv)) return usage();

    RTN_AddInstrumentFunction(function_handler, 0);

    PIN_AddFiniFunction(app_exit_handler, 0);

    // Start the program, never returns
    PIN_StartProgram();

    return 0;
}
