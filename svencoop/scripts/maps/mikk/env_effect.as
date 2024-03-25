#include "utils"
namespace env_effect
{
    void Register()
    {
        g_Util.ScriptAuthor.insertLast
        (
            "Script: env_effect\n"
            "Author: Mikk\n"
            "Github: github.com/Mikk155\n"
            "Feedback: KEZAEIV\n"
            "Description: entity that creates effects when trigger.\n"
        );
        g_Util.DebugMode( true );
        

        g_CustomEntityFuncs.RegisterCustomEntity( "env_effect::entity", "env_effect" );
		g_Game.PrecacheOther( 'env_effect' );
    }

    enum spawnflags
    {
        SPAWNFLAG_SPRITE      =  1  <<  0,
        SPAWNFLAG_SPRITEDROP  =  1  <<  1,
        SPAWNFLAG_QUAKETAR    =  1  <<  2,
        SPAWNFLAG_QUAKETELE   =  1  <<  3,
        SPAWNFLAG_SPARK       =  1  <<  4,
        SPAWNFLAG_FUNNEL      =  1  <<  5,
        SPAWNFLAG_FADESCREEN  =  1  <<  6,
        SPAWNFLAG_SOUNDEFFECT =  1  <<  7,
        SPAWNFLAG_BEAMDISK    =  1  <<  8,
        SPAWNFLAG_TRACER      =  1  <<  9,
        SPAWNFLAG_STREAKSPLASH=  1  <<  10,
        SPAWNFLAG_IMPLOSION   =  1  <<  11
    }

    class entity : ScriptBaseEntity
    {
        private string 
        sprite_model = "sprites/exit1.spr",
        sprite_rendercolor = "255 255 255",
        spritedrop_model = "sprites/hotglow.spr",
        sound_message = "debris/alien_teleport.wav",
        beamdisk_model = "sprites/laserbeam.spr",
        funnel_model = "sprites/glow01.spr";


        private float
        sprite_framerate = 10.0,
        sprite_scale = 1.0,
        sprite_duration = 1.0f,
        sprite_indelay = 0.0f,
        quaketar_delay = 0.0f,
        spark_delay = 0.0f,
        spritedrop_delay = 0.0f,
        funnel_delay = 0.0f,
        fadescreen_fadein = 0.2f,
        fadescreen_holdtime = 0.2f,
        fadescreen_fadeout = 0.5f,
        fadescreen_delay = 0.0f,
        sound_delay = 0.0f,
        beamdisk_delay = 0.0f,
        tracer_delay = 0.0f,
        splash_delay = 0.0f,
        implosion_delay = 0.0f,
        beamdisk_radius = 200.0f,
        teleport_delay = 0.0f;


        private int
        sprite_vp_type = 0,
        sprite_renderamt = 255,
        sprite_renderfx = 0,
        spritedrop_scale = 1,
        sprite_fadeout = 0,
        spritedrop_count = 4,
        funnel_flag = 0,
		spritedrop_life = 0,
        spritedrop_speedNoise = 8,
        fadescreen_renderamt = 100,
        sound_volume = 10,
        sound_attenuation = 0,
        fadescreen_radius = 512,
        beamdisk_holdtime = 10,
        sprite_rendermode = 5;


        private uint8
        beamdisk_renderamt = 255,
        tracer_holdtime = 32,
        tracer_length = 32,
        beamdisk_frame = 0,
		implosion_radius = 255,
        implosion_count = 32,
        implosion_life = 30;


        private uint16
        splash_speed = 1,
        splash_speednoise = 128,
        splash_count = 120;
        


        private uint
        tracer_color = 0,
        splash_color = 0;


        private Vector
        fadescreen_color = Vector( 0, 255, 0 ),
        beamdisk_color = Vector( 0, 255, 0 ),
        splash_velocity = Vector( 0, 0, 180 ),
        tracer_velocity = Vector( 0, 0, 180);


        bool KeyValue( const string& in szKey, const string& in szValue )
        {
            if( szKey == "spritedrop_life" )
            {
                spritedrop_life = atoi( szValue );
            }
            else if( szKey == "funnel_flag" )
            {
                funnel_flag = atoi( szValue );
            }
            else if( szKey == "spritedrop_count" )
            {
                spritedrop_count = atoi( szValue );
            }
            else if( szKey == "spritedrop_speedNoise" )
            {
                spritedrop_speedNoise = atoi( szValue );
            }
            else if( szKey == "spritedrop_scale" )
            {
                spritedrop_scale = atoi( szValue );
            }
            else if( szKey == "sprite_vp_type" )
            {
                sprite_vp_type = atoi( szValue );
            }
            else if( szKey == "sprite_rendercolor" )
            {
                sprite_rendercolor = szValue;
            }
            else if( szKey == "sprite_renderamt" )
            {
                sprite_renderamt = atoi( szValue );
            }
            else if( szKey == "sprite_renderfx" )
            {
                sprite_renderfx = atoi( szValue );
            }
            else if( szKey == "sprite_rendermode" )
            {
                sprite_rendermode = atoi( szValue );
            }
            else if( szKey == "sprite_fadeout" )
            {
                sprite_fadeout = atoi( szValue );
            }
            else if( szKey == "fadescreen_renderamt" )
            {
                fadescreen_renderamt = atoi( szValue );
            }
            else if( szKey == "fadescreen_radius" )
            {
                fadescreen_radius = atoi( szValue );
            }
            else if( szKey == "sound_volume" )
            {
                sound_volume = atoi( szValue );
            }
            else if( szKey == "sound_attenuation" )
            {
                sound_attenuation = atoi( szValue );
            }
            else if( szKey == "beamdisk_holdtime" )
            {
                beamdisk_holdtime = atoi( szValue );
            }
            else if( szKey == "beamdisk_renderamt" )
            {
                beamdisk_renderamt = atoui( szValue );
            }
            else if( szKey == "beamdisk_frame" )
            {
                beamdisk_frame = atoui( szValue );
            }
            else if( szKey == "implosion_radius" )
            {
                implosion_radius = atoui( szValue );
            }
            else if( szKey == "implosion_count" )
            {
                implosion_count = atoui( szValue );
            }
            else if( szKey == "implosion_life" )
            {
                implosion_life = atoui( szValue );
            }
            else if( szKey == "tracer_color" )
            {
                tracer_color = atoui( szValue );
            }
            else if( szKey == "tracer_holdtime" )
            {
                tracer_holdtime = atoui( szValue );
            }
            else if( szKey == "tracer_length" )
            {
                tracer_length = atoui( szValue );
            }
            else if( szKey == "splash_speed" )
            {
                splash_speed = atoui( szValue );
            }
            else if( szKey == "splash_count" )
            {
                splash_count = atoui( szValue );
            }
            else if( szKey == "splash_speednoise" )
            {
                splash_speednoise = atoui( szValue );
            }
            else if( szKey == "sprite_model" )
            {
                sprite_model = szValue;
            }
            else if( szKey == "spritedrop_model" )
            {
                spritedrop_model = szValue;
            }
            else if( szKey == "funnel_model" )
            {
                funnel_model = szValue;
            }
            else if( szKey == "sound_message" )
            {
                sound_message = szValue;
            }
            else if( szKey == "beamdisk_model" )
            {
                beamdisk_model = szValue;
            }
            else if( szKey == "sprite_indelay" )
            {
                sprite_indelay = atof( szValue );
            }
            else if( szKey == "quaketar_delay" )
            {
                quaketar_delay = atof( szValue );
            }
            else if( szKey == "teleport_delay" )
            {
                teleport_delay = atof( szValue );
            }
            else if( szKey == "spark_delay" )
            {
                spark_delay = atof( szValue );
            }
            else if( szKey == "spritedrop_delay" )
            {
                spritedrop_delay = atof( szValue );
            }
            else if( szKey == "funnel_delay" )
            {
                funnel_delay = atof( szValue );
            }
            else if( szKey == "sprite_duration" )
            {
                sprite_duration = atof( szValue );
            }
            else if( szKey == "sprite_framerate" )
            {
                sprite_framerate = atof( szValue );
            }
            else if( szKey == "sprite_scale" )
            {
                sprite_scale = atof( szValue );
            }
            else if( szKey == "fadescreen_holdtime" )
            {
                fadescreen_holdtime = atof( szValue );
            }
            else if( szKey == "fadescreen_fadeout" )
            {
                fadescreen_fadeout = atof( szValue );
            }
            else if( szKey == "fadescreen_fadein" )
            {
                fadescreen_fadein = atof( szValue );
            }
            else if( szKey == "sound_delay" )
            {
                sound_delay = atof( szValue );
            }
            else if( szKey == "beamdisk_delay" )
            {
                beamdisk_delay = atof( szValue );
            }
            else if( szKey == "tracer_delay" )
            {
                tracer_delay = atof( szValue );
            }
            else if( szKey == "splash_delay" )
            {
                splash_delay = atof( szValue );
            }
            else if( szKey == "implosion_delay" )
            {
                implosion_delay = atof( szValue );
            }
            else if( szKey == "beamdisk_radius" )
            {
                beamdisk_radius = atof( szValue );
            }
            else if( szKey == "fadescreen_color" )
            {
                g_Utility.StringToVector( fadescreen_color, szValue );
            }
            else if( szKey == "beamdisk_color" )
            {
                g_Utility.StringToVector( beamdisk_color, szValue );
            }
            else if( szKey == "tracer_velocity" )
            {
                g_Utility.StringToVector( tracer_velocity, szValue );
            }
            else if( szKey == "splash_velocity" )
            {
                g_Utility.StringToVector( splash_velocity, szValue );
            }
            else
            {
                return BaseClass.KeyValue( szKey, szValue );
            }
            return true;
        }

        void Precache()
        {
            g_Game.PrecacheModel( sprite_model );
            g_Game.PrecacheGeneric( sprite_model );

            g_Game.PrecacheModel( funnel_model );
            g_Game.PrecacheGeneric( funnel_model );

            g_Game.PrecacheModel( spritedrop_model );
            g_Game.PrecacheGeneric( spritedrop_model );

            g_Game.PrecacheModel( beamdisk_model );
            g_Game.PrecacheGeneric( beamdisk_model );

            g_Game.PrecacheModel( "sprites/steam1.spr" );
            g_Game.PrecacheGeneric( "sprites/steam1.spr" );

            g_SoundSystem.PrecacheSound( sound_message );
            g_Game.PrecacheGeneric( "sound/" + sound_message );

            BaseClass.Precache();
        }

        void Spawn()
        {
            Precache();

            BaseClass.Spawn();
        }

        void Use( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
        {
            if( self.pev.SpawnFlagBitSet( SPAWNFLAG_SPRITE ) )
            {
                g_Scheduler.SetTimeout( this, "csprite", sprite_indelay );
            }
            if( self.pev.SpawnFlagBitSet( SPAWNFLAG_SPRITEDROP ) )
            {
                g_Scheduler.SetTimeout( this, "cspritedrop", spritedrop_delay );
            }
            if( self.pev.SpawnFlagBitSet( SPAWNFLAG_QUAKETAR ) )
            {
                g_Scheduler.SetTimeout( this, "cquake", quaketar_delay, TE_TAREXPLOSION );
            }
            if( self.pev.SpawnFlagBitSet( SPAWNFLAG_QUAKETELE ) )
            {
                g_Scheduler.SetTimeout( this, "cquake", teleport_delay, TE_TELEPORT );
            }
            if( self.pev.SpawnFlagBitSet( SPAWNFLAG_SPARK ) )
            {
                g_Scheduler.SetTimeout( this, "cquake", spark_delay, TE_SPARKS );
            }
            if( self.pev.SpawnFlagBitSet( SPAWNFLAG_FUNNEL ) )
            {
                g_Scheduler.SetTimeout( this, "cfunnel", funnel_delay );
            }
            if( self.pev.SpawnFlagBitSet( SPAWNFLAG_BEAMDISK ) )
            {
                g_Scheduler.SetTimeout( this, "cbeamdisk", beamdisk_delay );
            }
            if( self.pev.SpawnFlagBitSet( SPAWNFLAG_TRACER ) )
            {
                g_Scheduler.SetTimeout( this, "ctracer", tracer_delay );
            }
            if( self.pev.SpawnFlagBitSet( SPAWNFLAG_STREAKSPLASH ) )
            {
                g_Scheduler.SetTimeout( this, "cstreaksplash", splash_delay );
            }
            if( self.pev.SpawnFlagBitSet( SPAWNFLAG_IMPLOSION ) )
            {
                g_Scheduler.SetTimeout( this, "cimplosion", implosion_delay );
            }

            for( int iPlayer = 1; iPlayer <= g_PlayerFuncs.GetNumPlayers(); ++iPlayer )
            {
                CBasePlayer@ pPlayer = g_PlayerFuncs.FindPlayerByIndex( iPlayer );

                if( pPlayer !is null )
                {
                    if( self.pev.SpawnFlagBitSet( SPAWNFLAG_FADESCREEN ) && ( self.pev.origin - pPlayer.pev.origin ).Length() <= fadescreen_radius )
                    {
                        g_Scheduler.SetTimeout( this, "cscreenfade", fadescreen_delay, @pPlayer, 1 );
                    }
                    if( self.pev.SpawnFlagBitSet( SPAWNFLAG_SOUNDEFFECT ) )
                    {
                        g_Scheduler.SetTimeout( this, "csound", sound_delay, @pPlayer );
                    }
                }
            }
        }
        
        void csprite()
        {
            dictionary g_keyvalues =
            {
                { "model", sprite_model },
                { "targetname", string( self.entindex() ) },
                { "framerate", string( sprite_framerate ) },
                { "scale", string( sprite_scale ) },
                { "vp_type", string( sprite_vp_type ) },
                { "rendercolor", sprite_rendercolor },
                { "renderamt", string( sprite_renderamt ) },
                { "rendermode", string( sprite_rendermode ) },
                { "renderfx", string( sprite_renderfx ) }
            };
            CBaseEntity@ pSprite = g_EntityFuncs.CreateEntity( "env_sprite", g_keyvalues );
            
            if( pSprite !is null )
            {
                g_EntityFuncs.SetOrigin( pSprite, self.pev.origin );
				pSprite.Use( self, self, USE_ON, 0.0f );
                g_Scheduler.SetTimeout( this, "Remove", sprite_duration, @pSprite, sprite_fadeout );
            }
        }

        void cquake( int effect = TE_SPARKS )
        {
            NetworkMessage Message( MSG_BROADCAST, NetworkMessages::SVC_TEMPENTITY, null );
                Message.WriteByte( effect );
                Message.WriteCoord( self.pev.origin.x );
                Message.WriteCoord( self.pev.origin.y );
                Message.WriteCoord( self.pev.origin.z );
            Message.End();
        }

        void cspritedrop()
        {
            NetworkMessage Message( MSG_BROADCAST, NetworkMessages::SVC_TEMPENTITY, null );
                Message.WriteByte( TE_SPRITETRAIL );
                Message.WriteCoord( self.pev.origin.x );
                Message.WriteCoord( self.pev.origin.y );
                Message.WriteCoord( self.pev.origin.z );
                Message.WriteCoord( self.pev.origin.x );
                Message.WriteCoord( self.pev.origin.y );
                Message.WriteCoord( self.pev.origin.z );
                Message.WriteShort( g_EngineFuncs.ModelIndex( spritedrop_model ) );
                Message.WriteByte( spritedrop_count );
                Message.WriteByte( spritedrop_life );
                Message.WriteByte( spritedrop_scale );
                Message.WriteByte( spritedrop_speedNoise );
                Message.WriteByte( 16 );
            Message.End();
        }

        void cfunnel()
        {
            NetworkMessage Message( MSG_BROADCAST, NetworkMessages::SVC_TEMPENTITY, null );
                Message.WriteByte( TE_LARGEFUNNEL );
                Message.WriteCoord( self.pev.origin.x );
                Message.WriteCoord( self.pev.origin.y );
                Message.WriteCoord( self.pev.origin.z );
                Message.WriteShort( g_EngineFuncs.ModelIndex( funnel_model ) );
                Message.WriteShort( funnel_flag );
            Message.End();
        }

        void Remove( CBaseEntity@ pEntity, const int& in iFade = 0 )
        {
            if( pEntity.pev.renderamt > 30 && iFade != 1 )
            {
                pEntity.pev.renderamt -= 30;
                g_Scheduler.SetTimeout( this, "Remove", 0.1f, @pEntity, 0 );
            }
            else
            {
                g_EntityFuncs.Remove( pEntity );
            }
        }

        void cscreenfade( CBasePlayer@ pPlayer, const int iflag = 1 )
        {
            g_PlayerFuncs.ScreenFade
            (
                pPlayer,
                fadescreen_color,
                ( iflag == 1 ? fadescreen_fadein : fadescreen_fadeout ),
                ( iflag == 1 ? fadescreen_holdtime : 0.0f ),
                fadescreen_renderamt,
                iflag
            );
            
            if( iflag == 1 )
            {
                g_Scheduler.SetTimeout( this, "cscreenfade", fadescreen_fadein + fadescreen_holdtime - 0.1f, @pPlayer, 0 );
            }
        }
        
        void csound( CBasePlayer@ pPlayer )
        {
            g_SoundSystem.PlaySound
            (
                /* edict_t@ entity */
                self.edict(),

                /* SOUND_CHANNEL channel */
                CHAN_AUTO,

                /* const string& in sample */
                sound_message,

                /* float volume */
                sound_volume/10,

                /* float attenuation */
                ( sound_attenuation == 0 )
                ? ATTN_IDLE :
                ( sound_attenuation == 1 )
                ? ATTN_STATIC :
                ( sound_attenuation == 2 )
                ? ATTN_NORM :
                ( sound_attenuation == 3 )
                ? ATTN_NONE
                : ATTN_STATIC,

                /* int flags */
                0,

                /* int pitch = PITCH_NORM */
                PITCH_NORM,

                /* int target_ent_unreliable = 0 */
                pPlayer.entindex(),

                /* bool setOrigin = false */
                true,

                /* const Vector& in vecOrigin = g_vecZero */
                ( sound_attenuation == 4 ) ? pPlayer.GetOrigin() : self.GetOrigin()
            );
        }

        void cbeamdisk()
        {
            NetworkMessage Message( MSG_BROADCAST, NetworkMessages::SVC_TEMPENTITY, null );
                Message.WriteByte(TE_BEAMDISK);
                Message.WriteCoord( self.pev.origin.x);
                Message.WriteCoord( self.pev.origin.y);
                Message.WriteCoord( self.pev.origin.z);
                Message.WriteCoord( self.pev.origin.x);
                Message.WriteCoord( self.pev.origin.y);
                Message.WriteCoord( self.pev.origin.z + beamdisk_radius );
                Message.WriteShort( g_EngineFuncs.ModelIndex( beamdisk_model ) );
                Message.WriteByte( beamdisk_frame );
                Message.WriteByte( 16 ); // Seems to have no effect, or at least i didn't notice
                Message.WriteByte( beamdisk_holdtime );
                Message.WriteByte(1); // "width" - has no effect
                Message.WriteByte(0); // "noise" - has no effect
                Message.WriteByte( atoui( beamdisk_color.x ) ); // R
                Message.WriteByte( atoui( beamdisk_color.y ) ); // G
                Message.WriteByte( atoui( beamdisk_color.z ) ); // B
                Message.WriteByte( beamdisk_renderamt ); // A
                Message.WriteByte( 0 ); // < 10 seems to have no effect while > 10 just expands it alot
            Message.End();
        }

        void ctracer()
        {
            NetworkMessage Message( MSG_BROADCAST, NetworkMessages::SVC_TEMPENTITY, null );
                Message.WriteByte( TE_USERTRACER );
                Message.WriteCoord( self.pev.origin.x );
                Message.WriteCoord( self.pev.origin.y );
                Message.WriteCoord( self.pev.origin.z );
                Message.WriteCoord( tracer_velocity.x  );
                Message.WriteCoord( tracer_velocity.y  );
                Message.WriteCoord( tracer_velocity.z  );
                Message.WriteByte( tracer_holdtime );
                Message.WriteByte( tracer_color );
                Message.WriteByte( tracer_length );
            Message.End();
        }

        void cstreaksplash()
        {
            NetworkMessage Message( MSG_BROADCAST, NetworkMessages::SVC_TEMPENTITY, null );
                Message.WriteByte( TE_STREAK_SPLASH );
                Message.WriteCoord( self.pev.origin.x );
                Message.WriteCoord( self.pev.origin.y );
                Message.WriteCoord( self.pev.origin.z );
                Message.WriteCoord( splash_velocity.x );
                Message.WriteCoord( splash_velocity.y );
                Message.WriteCoord( splash_velocity.z );
                Message.WriteByte( splash_color );
                Message.WriteShort( splash_count );
                Message.WriteShort( splash_speed );
                Message.WriteShort( splash_speednoise );
            Message.End();
        }

        void cimplosion()
        {
            NetworkMessage Message( MSG_BROADCAST, NetworkMessages::SVC_TEMPENTITY, null );
                Message.WriteByte( TE_IMPLOSION );
                Message.WriteCoord( self.pev.origin.x );
                Message.WriteCoord( self.pev.origin.y );
                Message.WriteCoord( self.pev.origin.z );
                Message.WriteByte( implosion_radius );
                Message.WriteByte( implosion_count );
                Message.WriteByte( implosion_life);
            Message.End();
        }
        
/*


    DYNAMIC LIGHT
    
    
    "void CPlayerFuncs::ConcussionEffect(CBaseEntity@ pEntity, float amplitude, float frequency, float fadeTime)": {
        "prefix": "ConcussionEffect",
        "body" : [ "ConcussionEffect( ${1:CBaseEntity@ pEntity}, ${2:float amplitude}, ${3:float frequency}, ${4:float fadeTime} )" ],
        "description" : "Applies concussion effect to a given player."
    },
    "void CEngineFuncs::ParticleEffect(const Vector& in vecOrigin, const Vector& in vecDir, float flColor, float flCount)": {
        "prefix": "ParticleEffect",
        "body" : [ "ParticleEffect( ${1:const Vector& in vecOrigin}, ${2:const Vector& in vecDir}, ${3:float flColor}, ${4:float flCount} )" ],
        "description" : "Emit a particle effect."
    },
*/
    }
}
// End of namespace
class Color
{ 
	uint8 r, g, b, a;
	
	Color() { r = g = b = a = 0; }
	Color(uint8 _r, uint8 _g, uint8 _b, uint8 _a = 255 ) { r = _r; g = _g; b = _b; a = _a; }
	Color (Vector v) { r = int(v.x); g = int(v.y); b = int(v.z); a = 255; }
	string ToString() { return "" + r + " " + g + " " + b + " " + a; }
}

const Color RED(255,0,0);
const Color GREEN(0,255,0);
const Color BLUE(0,0,255);




        // Aproved
        
        
        void te_smoke()
        {
            int scale=10;
            int frameRate=15;
            NetworkMessage Message( MSG_BROADCAST, NetworkMessages::SVC_TEMPENTITY, null );
                Message.WriteByte(TE_SMOKE);
                Message.WriteCoord( self.pev.origin.x );
                Message.WriteCoord( self.pev.origin.y );
                Message.WriteCoord( self.pev.origin.z );
                Message.WriteShort(g_EngineFuncs.ModelIndex("sprites/steam1.spr"));
                Message.WriteByte(scale);
                Message.WriteByte(frameRate);
            Message.End();
        }
        
        void te_beamcylinder()
        {
            float radius = 128;
            uint8 startFrame=0; 
            uint8 frameRate=16;
            uint8 life=8;
            uint8 width=8;
            uint8 noise=0;
            Color c=GREEN;
            uint8 scrollSpeed=0;
            NetworkMessage Message( MSG_BROADCAST, NetworkMessages::SVC_TEMPENTITY, null );
                Message.WriteByte(TE_BEAMCYLINDER);
                Message.WriteCoord(self.pev.origin.x);
                Message.WriteCoord(self.pev.origin.y);
                Message.WriteCoord(self.pev.origin.z);
                Message.WriteCoord(self.pev.origin.x);
                Message.WriteCoord(self.pev.origin.y);
                Message.WriteCoord(self.pev.origin.z + radius);
                Message.WriteShort(g_EngineFuncs.ModelIndex("sprites/laserbeam.spr"));
                Message.WriteByte(startFrame);
                Message.WriteByte(frameRate);
                Message.WriteByte(life);
                Message.WriteByte(width);
                Message.WriteByte(noise);
                Message.WriteByte(c.r);
                Message.WriteByte(c.g);
                Message.WriteByte(c.b);
                Message.WriteByte(c.a);
                Message.WriteByte(scrollSpeed);
            Message.End();
        }
        
        void te_beamtorus()
        {
            float radius = 128;
            uint8 startFrame=0;
            uint8 frameRate=16;
            uint8 life=8;
            uint8 width=8;
            uint8 noise=0;
            Color c=GREEN;
            uint8 scrollSpeed=0;
            NetworkMessage Message( MSG_BROADCAST, NetworkMessages::SVC_TEMPENTITY, null );
            Message.WriteByte(TE_BEAMTORUS);
            Message.WriteCoord(self.pev.origin.x);
            Message.WriteCoord(self.pev.origin.y);
            Message.WriteCoord(self.pev.origin.z);
            Message.WriteCoord(self.pev.origin.x);
            Message.WriteCoord(self.pev.origin.y);
            Message.WriteCoord(self.pev.origin.z + radius);
            Message.WriteShort(g_EngineFuncs.ModelIndex("sprites/laserbeam.spr"));
            Message.WriteByte(startFrame);
            Message.WriteByte(frameRate);
            Message.WriteByte(life);
            Message.WriteByte(width);
            Message.WriteByte(noise);
            Message.WriteByte(c.r);
            Message.WriteByte(c.g);
            Message.WriteByte(c.b);
            Message.WriteByte(c.a);
            Message.WriteByte(scrollSpeed);
            Message.End();
        }
        