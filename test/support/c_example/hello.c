#include "hello.h"

const char* hello(int to)
{
    switch(to)
    {
        case world:
            return "world";
            break;

        case planet:
            return "planet";
            break;

        case universe:
            return "universe";
            break;

        default:
            return "you";        
    }
};
