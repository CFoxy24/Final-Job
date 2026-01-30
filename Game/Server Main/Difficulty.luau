local module = {}

local Difficulties = {}


Difficulties.Animatronics_BaseValues = 
	{
		Freddy = 
		{
			SlowWalkSpeed = 6,
			WalkSpeed = 7,
			RunAddedSpeed = 7,

			ViewDistance = 40,
			VisionCone = 70,
			
		},
		
		Bonnie = 
		{
			SlowWalkSpeed = 6,
			WalkSpeed = 7,
			RunAddedSpeed = 7,

			ViewDistance = 40,
			VisionCone = 70,
		},
		
		Chica = 
		{
			SlowWalkSpeed = 6,
			WalkSpeed = 7,
			RunAddedSpeed = 7,

			ViewDistance = 40,
			VisionCone = 70,
		},
		Foxy = 
		{
			SlowWalkSpeed = 9,
			WalkSpeed = 10,
			RunAddedSpeed = 12,

			ViewDistance = 40,
			VisionCone = 70,
		},
		Endo = 
		{
			SlowWalkSpeed = 6,
			WalkSpeed = 7,
			RunAddedSpeed = 9,

			ViewDistance = 40,
			VisionCone = 70,
		}
		


	}

Difficulties.Animatronics_Multipliers = 
	{
		Night1 = 
		{
			{
				{"Bonnie", "Chica", "Freddy", "Foxy"},
				{"VisionCone"},
				50,
			},
			{
				{"Bonnie", "Chica", "Freddy", "Foxy"},
				{"ViewDistance"},
				30,
			},
			{
				{"Bonnie", "Chica", "Freddy", "Foxy"},
				{"SlowWalkSpeed", "WalkSpeed", "RunAddedSpeed"},
				5,
			}
		},
		Night2 = 
		{
			{
				{"Bonnie", "Chica", "Freddy", "Foxy"},
				{"VisionCone"},
				55,
			},
			{
				{"Bonnie", "Chica", "Freddy", "Foxy"},
				{"ViewDistance"},
				40,
			},
			{
				{"Bonnie", "Chica", "Freddy", "Foxy"},
				{"SlowWalkSpeed", "WalkSpeed", "RunAddedSpeed"},
				6,
			}
		},
		Night3 = 
		{
			{
				{"Bonnie", "Chica", "Freddy", "Foxy"},
				{"VisionCone"},
				60,
			},
			{
				{"Bonnie", "Chica", "Freddy", "Foxy"},
				{"ViewDistance"},
				45,
			},
			{
				{"Bonnie", "Chica", "Freddy", "Foxy"},
				{"SlowWalkSpeed", "WalkSpeed", "RunAddedSpeed"},
				6.5,
			}
		},
		Night4 = 
		{
			{
				{"Bonnie", "Chica", "Freddy", "Foxy"},
				{"VisionCone"},
				70,
			},
			{
				{"Bonnie", "Chica", "Freddy", "Foxy"},
				{"ViewDistance"},
				50,
			},
			{
				{"Bonnie", "Chica", "Freddy"},
				{"SlowWalkSpeed", "WalkSpeed", "RunAddedSpeed"},
				7,
			},
			{
				{"Foxy"},
				{"SlowWalkSpeed", "WalkSpeed", "RunAddedSpeed"},
				9,
				
			}
		},
		Night5 = 
		{
			{
				{"Bonnie", "Chica", "Freddy", "Foxy"},
				{"VisionCone"},
				80,
			},
			{
				{"Bonnie", "Chica", "Freddy", "Foxy"},
				{"ViewDistance"},
				55,
			},
			{
				{"Bonnie", "Chica", "Freddy"},
				{"SlowWalkSpeed", "WalkSpeed", "RunAddedSpeed"},
				7.5,
			},
			{
				{"Foxy"},
				{"RunAddedSpeed"},
				9,

			}
		}
		,Night6 = 
		{
			{
				{"Bonnie", "Chica", "Freddy", "Foxy"},
				{"VisionCone"},
				80,
			},
			{
				{"Bonnie", "Chica", "Freddy", "Foxy"},
				{"ViewDistance"},
				60,
			},
			{
				{"Bonnie", "Chica", "Freddy"},
				{"SlowWalkSpeed", "WalkSpeed", "RunAddedSpeed"},
				8,
			},
			{
				{"Foxy"},
				{"RunAddedSpeed"},
				9,

			}
		}
	}

Difficulties.Animatronics_UpTime = 
	{
		Night1 = 
		{
			Chica = math.random(180,210),
			Bonnie = math.random(120,150),
			Freddy = 600,
			Foxy = 600
		},
		Night2 = 
		{
			Chica = math.random(120,150),
			Bonnie = math.random(100,130),
			Freddy = 600,
			Foxy = 600
		},
		Night3 = 
		{
			Chica = math.random(120,130),
			Bonnie = math.random(85,110),
			Freddy = math.random(320,360),
			Foxy = 600
		},
		Night4 = 
		{
			Chica = math.random(100,110),
			Bonnie = math.random(60,80),
			Freddy = math.random(180,200),
			Foxy = 240
		},
		Night5 = 
		{
			Chica = math.random(70,80),
			Bonnie = math.random(40,60),
			Freddy = math.random(120,140),
			Foxy = 180
		},
		Night6 = 
		{
			Chica = math.random(50,70),
			Bonnie = math.random(20,40),
			Freddy = math.random(60,80),
			Foxy = 1,
			Endo = math.random(120,140)
		}
	}


function module.Get(which)
	return Difficulties[which]
end

return module
