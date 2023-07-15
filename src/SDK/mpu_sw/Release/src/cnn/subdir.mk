################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../src/cnn/cnn_algorithm.c \
../src/cnn/cnn_func.c 

OBJS += \
./src/cnn/cnn_algorithm.o \
./src/cnn/cnn_func.o 

C_DEPS += \
./src/cnn/cnn_algorithm.d \
./src/cnn/cnn_func.d 


# Each subdirectory must supply rules for building sources it contributes
src/cnn/%.o: ../src/cnn/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: MicroBlaze gcc compiler'
	mb-gcc -Wall -O3 -g -c -fmessage-length=0 -I../../mpu_bsp/microblaze_0/include -mlittle-endian -mxl-barrel-shift -mxl-pattern-compare -mno-xl-soft-div -mcpu=v8.50.a -mno-xl-soft-mul -mxl-multiply-high -mhard-float -mxl-float-convert -mxl-float-sqrt -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


