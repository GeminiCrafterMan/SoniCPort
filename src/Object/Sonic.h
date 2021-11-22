#pragma once

#include "Object.h"

#include <stdint.h>
#include "Types.h"

//Sonic constants
#define SONIC_WIDTH       9
#define SONIC_HEIGHT      19
#define SONIC_BALL_WIDTH  7
#define SONIC_BALL_HEIGHT 14
#define SONIC_BALL_SHIFT  5

#define SONIC_DPLC_SIZE 0x2E0

//Sonic assets
extern const uint8_t map_sonic[];
extern const uint8_t anim_sonic[];

//Sonic scratch structure
typedef struct
{
	uint8_t air;                 //0x28
	uint8_t spindash;			 // obSpindash, it's a byte
	uint16_t spindashCounter;	 // obSpindashCounter, it's a word
	uint8_t pad0[5];             //0x2B - 0x2F
	uint16_t flash_time;         //0x30
	uint16_t invincibility_time; //0x32
	uint16_t shoes_time;         //0x34
	uint8_t front_angle;         //0x36
	uint8_t back_angle;          //0x37
	union
	{
		uint8_t floor_clip;
		int16_t death_y;
	} x38;                       //0x38
	int16_t death_timer;         //0x3A
	uint8_t jumping;             //0x3C
	uint8_t standing_obj;        //0x3D
	uint16_t control_lock;       //0x3E
} Scratch_Sonic;

//Sonic globals
extern int16_t sonspeed_max, sonspeed_acc, sonspeed_dec;

extern uint8_t sonframe_num, sonframe_chg;
extern uint8_t sgfx_buffer[SONIC_DPLC_SIZE];

extern int16_t track_sonic[0x40][2];
extern word_u track_pos;

//Sonic types
typedef enum
{
	SonAnimId_Walk,
	SonAnimId_Run,
	SonAnimId_Roll,
	SonAnimId_Roll2,
	SonAnimId_Push,
	SonAnimId_Wait,
	SonAnimId_Balance,
	SonAnimId_LookUp,
	SonAnimId_Duck,
	SonAnimId_Spindash,
	SonAnimId_Fall,
	SonAnimId_Balance2,
	SonAnimId_TPose1,
	SonAnimId_Stop,
	SonAnimId_Float1,
	SonAnimId_Float2,
	SonAnimId_Spring,
	SonAnimId_Hang,
	SonAnimId_TPose2,
	SonAnimId_TPose3,
	SonAnimId_TPose4,
	SonAnimId_GetAir,
	SonAnimId_Burnt,
	SonAnimId_Drown,
	SonAnimId_Death,
	SonAnimId_TPose5,
	SonAnimId_Hurt,
	SonAnimId_WaterSlid,
	SonAnimId_Null,
	SonAnimId_Float3,
	SonAnimId_Float4,
	SonAnimId_TPose6,
	SonAnimId_TPose7,
	SonAnimId_TPose8,
	SonAnimId_DropDash,
	SonAnimId_TPose9,
	SonAnimId_MachSpeed,
	SonAnimId_Victory,
} SonAnimId;

static const uint16_t SpindashSpeeds[9] = {
  0x800,
  0x880,
  0x900,
  0x980,
  0xA00,
  0xA80,
  0xB00,
  0xB80,
  0xC00
};

//Sonic functions
void Sonic_Animate(Object *obj);
void Sonic_LoadGfx(Object *obj);
void Sonic_ResetOnFloor(Object *obj);
signed int HurtSonic(Object *obj, Object *src);
signed int KillSonic(Object *obj, Object *src);
