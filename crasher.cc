#include <thread>
#include <chrono>
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

void crash()
{
    std::cout << "crashing" << std::endl;
    std::this_thread::sleep_for( std::chrono::seconds( 13 ) );
    bool* nothing;
    delete nothing;
    delete nothing;
}

int main()
{
    std::thread start_count( print_count );
    std::thread then_crash( crash );
    start_count.join();
    return 0;
}


