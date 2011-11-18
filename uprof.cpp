// Copyright (c) 2011, Jon Maken
// License: 3-clause BSD
// Revision: 11/15/2011 8:38:48 PM

#include <iostream>
#include "pin.H"
using namespace std;

extern VOID function_handler(RTN, VOID*);
extern VOID app_exit_handler(INT32, VOID*);

KNOB<string> KnobOutputFile(KNOB_MODE_WRITEONCE, "pintool",
    "o", "profile_data.out", "specify profile results file");

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
