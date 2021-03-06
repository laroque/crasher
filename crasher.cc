#include <thread>
#include <chrono>
#include <sstream>
#include <iostream>

void print_count()
{
    int i = 0;
    while (true)
    {
        std::this_thread::sleep_for( std::chrono::milliseconds( 100 ) );
        std::cout << " at iteration " << i << std::endl;
        i++;
    }
}

void crash( int delay )
{
    std::cout << "crashing in " << delay << " seconds" << std::endl;
    std::this_thread::sleep_for( std::chrono::seconds( delay ) );
    bool* nothing;
    delete nothing;
    delete nothing;
}

int main(int argc, char** argv)
{
    std::cout << "input is: ";
    for (int i=1; i<argc; ++i) {
        std::cout << argv[i] << " ";
    }
    std::cout << std::endl;
    int a_delay = 13;
    if (argc  == 2) {
        std::istringstream iss( argv[1] );
        if (!(iss >> a_delay)) {
            std::cout << "unable to convert argument" << std::endl;
        }
    }
    std::thread start_count( print_count );
    std::thread then_crash( crash, a_delay );
    start_count.join();
    return 0;
}
