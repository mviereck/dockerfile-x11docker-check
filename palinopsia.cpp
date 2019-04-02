
#include<SDL2/SDL.h>
#include <GL/gl.h>
#include <GL/glu.h>
#include<stdio.h>
#include<string>
#include<iostream>

SDL_Window * window;
SDL_Renderer *renderer;
SDL_Surface *window_surface;
SDL_Event event;

int main(int argc, char** argv){


    if (argc<4) {
        std::cout << "USAGE:"
            << std::endl
            << argv[0] <<"<WIDTH> <HEIGHT> <MEGABYTES> "
            << std::endl;
        return -1;
    }

    bool running = true;
    int current = 0;

    int width  = std::stoi(std::string(argv[1]));
    int height = std::stoi(std::string(argv[2]));

    int NUM_BUFFERS =
        std::stoi(std::string(argv[3]));

    NUM_BUFFERS = NUM_BUFFERS*1024*1024;
    NUM_BUFFERS = NUM_BUFFERS / (width * height * 4);

    std::cout << NUM_BUFFERS << std::endl;

    SDL_Init(SDL_INIT_VIDEO);

    SDL_CreateWindowAndRenderer(
            width*0.8,
            height*0.8,
            0,
            &window,
            &renderer);

    SDL_Texture* txt[NUM_BUFFERS];

    for (int i=0; i<NUM_BUFFERS; i++) {
        std::cout << "now initializing buffer nr. "
            << i << " of "
            << NUM_BUFFERS << std::endl;


        txt[i] = SDL_CreateTexture(renderer,
                SDL_PIXELFORMAT_ARGB8888,
                SDL_TEXTUREACCESS_STREAMING,
                width,
                height
                );
    }


    while(running){
        SDL_RenderClear(renderer);
        SDL_RenderCopy(renderer,
                txt[current],
                NULL,
                NULL);
        SDL_RenderPresent(renderer);

        if (SDL_PollEvent(&event)){

            if(event.type == SDL_KEYDOWN){
                if (event.key.keysym.sym == SDLK_ESCAPE){
                    running = false;
                }
                if (event.key.keysym.sym == SDLK_RIGHT){
                    current++;
                }
                if (event.key.keysym.sym == SDLK_LEFT){
                    current--;
                }
                if (event.key.keysym.sym == SDLK_UP){
                    current+=10;
                }
                if (event.key.keysym.sym == SDLK_DOWN){
                    current-=10;
                }
                if (event.key.keysym.sym == SDLK_SPACE){

                    int w,h;

                    std::string filename = "frame_" + std::to_string(current) + ".bmp";
                    std::cout << "saving frame " <<  current << std::endl;

                    SDL_GetWindowSize(window, &w, &h);

                    window_surface = SDL_CreateRGBSurface(0, w, h,
                            32, 0x00ff0000, 0x0000ff00, 0x000000ff, 0xff000000);

                    window_surface = SDL_GetWindowSurface(window);

                    SDL_RenderReadPixels(renderer, nullptr,
                            SDL_PIXELFORMAT_ARGB8888,
                            window_surface->pixels,
                            window_surface->pitch);

                    if (SDL_SaveBMP(window_surface, filename.c_str())<=0){
                        std::cout << SDL_GetError() << std::endl;
                    }

                    SDL_FreeSurface(window_surface);
                }
                current = current % NUM_BUFFERS;
                if (current<0) current = NUM_BUFFERS+current;
                std::cout << "now displaying buffer nr. "
                    << current << " of "
                    << NUM_BUFFERS << std::endl;
            }

            if (event.type==SDL_QUIT){
                running = false;
            }

        }
    }

    for (int i=0; i<NUM_BUFFERS; i++) {
        SDL_DestroyTexture(txt[i]);
    }

    //SDL_DestroyTexture(txt);
}

