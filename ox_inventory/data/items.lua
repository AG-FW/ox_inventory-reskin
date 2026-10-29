return {
    ['gym_protein']    = { name = 'gym_protein',    label = 'Protein Shake', weight = 200, type = 'item', image = 'protein.png',    unique = false, useable = true, shouldClose = true, description = 'Gym supplement' },
['gym_preworkout'] = { name = 'gym_preworkout', label = 'Pre-Workout',   weight = 200, type = 'item', image = 'preworkout.png', unique = false, useable = true, shouldClose = true, description = 'Gym supplement' },
['gym_creatine']   = { name = 'gym_creatine',   label = 'Creatine',      weight = 200, type = 'item', image = 'creatine.png',   unique = false, useable = true, shouldClose = true, description = 'Gym supplement' },
['jump_rope']      = { name = 'jump_rope',      label = 'Jump Rope',     weight = 500, type = 'item', image = 'jump_rope.png',  unique = false, useable = true, shouldClose = true, description = 'Portable jump rope' },
    ['testburger'] = {
        label = 'Test Burger',
        weight = 220,
        degrade = 60,
        client = {
            image = 'burger_chicken.png',
            status = { hunger = 200000 },
            anim = 'eating',
            prop = 'burger',
            usetime = 2500,
            export = 'ox_inventory_examples.testburger'
        },
        server = {
            export = 'ox_inventory_examples.testburger',
            test = 'what an amazingly delicious burger, amirite?'
        },
        buttons = {
            {
                label = 'Lick it',
                action = function(slot)
                    print('You licked the burger')
                end
            },
            {
                label = 'Squeeze it',
                action = function(slot)
                    print('You squeezed the burger :(')
                end
            },
            {
                label = 'What do you call a vegan burger?',
                group = 'Hamburger Puns',
                action = function(slot)
                    print('A misteak.')
                end
            },
            {
                label = 'What do frogs like to eat with their hamburgers?',
                group = 'Hamburger Puns',
                action = function(slot)
                    print('French flies.')
                end
            },
            {
                label = 'Why were the burger and fries running?',
                group = 'Hamburger Puns',
                action = function(slot)
                    print('Because they\'re fast food.')
                end
            }
        },
        consume = 0.3
    },
['rental_contract'] = {
    label = 'Rental Contract',
    weight = 10,
    stack = false,
    close = true,
    description = 'Vehicle rental agreement.',
    client = {
        image = 'rental_contract.png',
        export = 'codelab_rentals.useContract',
    },
},
    ['bandage'] = {
        label = 'Bandage',
        weight = 115,
    },
-- Utility Skate
["skate"] = {
    label = "Skateboard",
    weight = 1500,
    stack = false,
},
-- Wheels Classic
["wheels_classic_1"] = {
    label = "Wheels classic 1",
    weight = 250,
    stack = true,
},
["wheels_classic_2"] = {
    label = "Wheels classic 2",
    weight = 250,
    stack = true,
},
["wheels_classic_3"] = {
    label = "Wheels classic 3",
    weight = 250,
    stack = true,
},
["wheels_classic_4"] = {
    label = "Wheels classic 4",
    weight = 250,
    stack = true,
},
["wheels_classic_5"] = {
    label = "Wheels classic 5",
    weight = 250,
    stack = true,
},
["wheels_classic_6"] = {
    label = "Wheels classic 6",
    weight = 250,
    stack = true,
},
["wheels_classic_7"] = {
    label = "Wheels classic 7",
    weight = 250,
    stack = true,
},
["wheels_classic_8"] = {
    label = "Wheels classic 8",
    weight = 250,
    stack = true,
},
["wheels_classic_9"] = {
    label = "Wheels classic 9",
    weight = 250,
    stack = true,
},
["wheels_classic_10"] = {
    label = "Wheels classic 10",
    weight = 250,
    stack = true,
},
["wheels_classic_11"] = {
    label = "Wheels classic 11",
    weight = 250,
    stack = true,
},
["wheels_classic_12"] = {
    label = "Wheels classic 12",
    weight = 250,
    stack = true,
},
["wheels_classic_13"] = {
    label = "Wheels classic 13",
    weight = 250,
    stack = true,
},
["wheels_classic_14"] = {
    label = "Wheels classic 14",
    weight = 250,
    stack = true,
},
["wheels_classic_15"] = {
    label = "Wheels classic 15",
    weight = 250,
    stack = true,
},
["wheels_classic_16"] = {
    label = "Wheels classic 16",
    weight = 250,
    stack = true,
},
["wheels_classic_17"] = {
    label = "Wheels classic 17",
    weight = 250,
    stack = true,
},
["wheels_classic_18"] = {
    label = "Wheels classic 18",
    weight = 250,
    stack = true,
},
["wheels_classic_19"] = {
    label = "Wheels classic 19",
    weight = 250,
    stack = true,
},
["wheels_classic_20"] = {
    label = "Wheels classic 20",
    weight = 250,
    stack = true,
},
-- Truckplates Classic
["truckplate_classic_1"] = {
    label = "Truckplate classic 1",
    weight = 200,
    stack = true,
},
["truckplate_classic_2"] = {
    label = "Truckplate classic 2",
    weight = 200,
    stack = true,
},
["truckplate_classic_3"] = {
    label = "Truckplate classic 3",
    weight = 200,
    stack = true,
},
["truckplate_classic_4"] = {
    label = "Truckplate classic 4",
    weight = 200,
    stack = true,
},
["truckplate_classic_5"] = {
    label = "Truckplate classic 5",
    weight = 200,
    stack = true,
},
["truckplate_classic_6"] = {
    label = "Truckplate classic 6",
    weight = 200,
    stack = true,
},
["truckplate_classic_7"] = {
    label = "Truckplate classic 7",
    weight = 200,
    stack = true,
},
["truckplate_classic_8"] = {
    label = "Truckplate classic 8",
    weight = 200,
    stack = true,
},
["truckplate_classic_9"] = {
    label = "Truckplate classic 9",
    weight = 200,
    stack = true,
},
["truckplate_classic_10"] = {
    label = "Truckplate classic 10",
    weight = 200,
    stack = true,
},
["truckplate_classic_11"] = {
    label = "Truckplate classic 11",
    weight = 200,
    stack = true,
},
-- Boards Classic
["board_classic_1"] = {
    label = "Board classic 1",
    weight = 1000,
    stack = true,
},
["board_classic_2"] = {
    label = "Board classic 2",
    weight = 1000,
    stack = true,
},
["board_classic_3"] = {
    label = "Board classic 3",
    weight = 1000,
    stack = true,
},
["board_classic_4"] = {
    label = "Board classic 4",
    weight = 1000,
    stack = true,
},
["board_classic_5"] = {
    label = "Board classic 5",
    weight = 1000,
    stack = true,
},
["board_classic_6"] = {
    label = "Board classic 6",
    weight = 1000,
    stack = true,
},
["board_classic_7"] = {
    label = "Board classic 7",
    weight = 1000,
    stack = true,
},
["board_classic_8"] = {
    label = "Board classic 8",
    weight = 1000,
    stack = true,
},
["board_classic_9"] = {
    label = "Board classic 9",
    weight = 1000,
    stack = true,
},
["board_classic_10"] = {
    label = "Board classic 10",
    weight = 1000,
    stack = true,
},
["board_classic_11"] = {
    label = "Board classic 11",
    weight = 1000,
    stack = true,
},
["board_classic_12"] = {
    label = "Board classic 12",
    weight = 1000,
    stack = true,
},
["board_classic_13"] = {
    label = "Board classic 13",
    weight = 1000,
    stack = true,
},
["board_classic_14"] = {
    label = "Board classic 14",
    weight = 1000,
    stack = true,
},
["board_classic_15"] = {
    label = "Board classic 15",
    weight = 1000,
    stack = true,
},
["board_classic_16"] = {
    label = "Board classic 16",
    weight = 1000,
    stack = true,
},
["board_classic_17"] = {
    label = "Board classic 17",
    weight = 1000,
    stack = true,
},
["board_classic_18"] = {
    label = "Board classic 18",
    weight = 1000,
    stack = true,
},
["board_classic_19"] = {
    label = "Board classic 19",
    weight = 1000,
    stack = true,
},
["board_classic_20"] = {
    label = "Board classic 20",
    weight = 1000,
    stack = true,
},
["board_classic_21"] = {
    label = "Board classic 21",
    weight = 1000,
    stack = true,
},
["board_classic_22"] = {
    label = "Board classic 22",
    weight = 1000,
    stack = true,
},
["board_classic_23"] = {
    label = "Board classic 23",
    weight = 1000,
    stack = true,
},
["board_classic_24"] = {
    label = "Board classic 24",
    weight = 1000,
    stack = true,
},
["board_classic_25"] = {
    label = "Board classic 25",
    weight = 1000,
    stack = true,
},
["board_classic_26"] = {
    label = "Board classic 26",
    weight = 1000,
    stack = true,
},
["board_classic_27"] = {
    label = "Board classic 27",
    weight = 1000,
    stack = true,
},
["board_classic_28"] = {
    label = "Board classic 28",
    weight = 1000,
    stack = true,
},
    ['burger'] = {
        label = 'Burger',
        weight = 220,
        client = {
            status = { hunger = 200000 },
            anim = 'eating',
            prop = 'burger',
            usetime = 2500,
            notification = 'You ate a delicious burger'
        },
    },

    ['sprunk'] = {
        label = 'Sprunk',
        weight = 350,
        client = {
            status = { thirst = 200000 },
            anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
            prop = { model = `prop_ld_can_01`, pos = vec3(0.01, 0.01, 0.06), rot = vec3(5.0, 5.0, -180.5) },
            usetime = 2500,
            notification = 'You quenched your thirst with a sprunk'
        }
    },

    ['parachute'] = {
        label = 'Parachute',
        weight = 8000,
        stack = false,
        client = {
            anim = { dict = 'clothingshirt', clip = 'try_shirt_positive_d' },
            usetime = 1500
        }
    },

    ['garbage'] = {
        label = 'Garbage',
    },

    ['paperbag'] = {
        label = 'Paper Bag',
        weight = 1,
        stack = false,
        close = false,
        consume = 0
    },

    ['panties'] = {
        label = 'Knickers',
        weight = 10,
        consume = 0,
        client = {
            status = { thirst = -100000, stress = -25000 },
            anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
            prop = { model = `prop_cs_panties_02`, pos = vec3(0.03, 0.0, 0.02), rot = vec3(0.0, -13.5, -1.5) },
            usetime = 2500,
        }
    },

    ['lockpick'] = {
        label = 'Lockpick',
        weight = 160,
    },

    ['phone'] = {
        label = 'Phone',
        weight = 190,
        stack = false,
        consume = 0,
        client = {
            add = function(total)
                if total > 0 then
                    pcall(function() return exports.npwd:setPhoneDisabled(false) end)
                end
            end,

            remove = function(total)
                if total < 1 then
                    pcall(function() return exports.npwd:setPhoneDisabled(true) end)
                end
            end
        }
    },

    ['mustard'] = {
        label = 'Mustard',
        weight = 500,
        client = {
            status = { hunger = 25000, thirst = 25000 },
            anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
            prop = { model = `prop_food_mustard`, pos = vec3(0.01, 0.0, -0.07), rot = vec3(1.0, 1.0, -1.5) },
            usetime = 2500,
            notification = 'You... drank mustard'
        }
    },

    ['water'] = {
        label = 'Water',
        weight = 500,
        client = {
            status = { thirst = 200000 },
            anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
            prop = { model = `prop_ld_flow_bottle`, pos = vec3(0.03, 0.03, 0.02), rot = vec3(0.0, 0.0, -1.5) },
            usetime = 2500,
            cancel = true,
            notification = 'You drank some refreshing water'
        }
    },

    ['armour'] = {
        label = 'Bulletproof Vest',
        weight = 3000,
        stack = false,
        client = {
            anim = { dict = 'clothingshirt', clip = 'try_shirt_positive_d' },
            usetime = 3500
        }
    },

    ['clothing'] = {
        label = 'Clothing',
        consume = 0,
    },

    ['money'] = {
        label = 'Money',
    },

    ['black_money'] = {
        label = 'Dirty Money',
    },

    ['id_card'] = {
        label = 'Identification Card',
    },

    ['driver_license'] = {
        label = 'Drivers License',
    },

    ['weaponlicense'] = {
        label = 'Weapon License',
    },

    ['lawyerpass'] = {
        label = 'Lawyer Pass',
    },

    ['radio'] = {
        label = 'Radio',
        weight = 1000,
        allowArmed = true,
        consume = 0,
        client = {
            event = 'mm_radio:client:use'
        }
    },

    ['jammer'] = {
        label = 'Radio Jammer',
        weight = 10000,
        allowArmed = true,
        client = {
            event = 'mm_radio:client:usejammer'
        }
    },

    ['radiocell'] = {
        label = 'AAA Cells',
        weight = 1000,
        stack = true,
        allowArmed = true,
        client = {
            event = 'mm_radio:client:recharge'
        }
    },

    ['advancedlockpick'] = {
        label = 'Advanced Lockpick',
        weight = 500,
    },

    ['screwdriverset'] = {
        label = 'Screwdriver Set',
        weight = 500,
    },

    ['electronickit'] = {
        label = 'Electronic Kit',
        weight = 500,
    },

    ['cleaningkit'] = {
        label = 'Cleaning Kit',
        weight = 500,
    },

    ['repairkit'] = {
        label = 'Repair Kit',
        weight = 2500,
    },

    ['advancedrepairkit'] = {
        label = 'Advanced Repair Kit',
        weight = 4000,
    },

    ['diamond_ring'] = {
        label = 'Diamond',
        weight = 1500,
    },

    ['rolex'] = {
        label = 'Golden Watch',
        weight = 1500,
    },

    ['goldbar'] = {
        label = 'Gold Bar',
        weight = 1500,
    },

    ['goldchain'] = {
        label = 'Golden Chain',
        weight = 1500,
    },

    ['crack_baggy'] = {
        label = 'Crack Baggy',
        weight = 100,
    },

    ['cokebaggy'] = {
        label = 'Bag of Coke',
        weight = 100,
    },

    ['coke_brick'] = {
        label = 'Coke Brick',
        weight = 2000,
    },

    ['coke_small_brick'] = {
        label = 'Coke Package',
        weight = 1000,
    },

    ['xtcbaggy'] = {
        label = 'Bag of Ecstasy',
        weight = 100,
    },

    ['meth'] = {
        label = 'Methamphetamine',
        weight = 100,
    },

    ['oxy'] = {
        label = 'Oxycodone',
        weight = 100,
    },

    ['weed_ak47'] = {
        label = 'AK47 2g',
        weight = 200,
    },

    ['weed_ak47_seed'] = {
        label = 'AK47 Seed',
        weight = 1,
    },

    ['weed_skunk'] = {
        label = 'Skunk 2g',
        weight = 200,
    },

    ['weed_skunk_seed'] = {
        label = 'Skunk Seed',
        weight = 1,
    },

    ['weed_amnesia'] = {
        label = 'Amnesia 2g',
        weight = 200,
    },

    ['weed_amnesia_seed'] = {
        label = 'Amnesia Seed',
        weight = 1,
    },

    ['weed_og-kush'] = {
        label = 'OGKush 2g',
        weight = 200,
    },

    ['weed_og-kush_seed'] = {
        label = 'OGKush Seed',
        weight = 1,
    },

    ['weed_white-widow'] = {
        label = 'OGKush 2g',
        weight = 200,
    },

    ['weed_white-widow_seed'] = {
        label = 'White Widow Seed',
        weight = 1,
    },

    ['weed_purple-haze'] = {
        label = 'Purple Haze 2g',
        weight = 200,
    },

    ['weed_purple-haze_seed'] = {
        label = 'Purple Haze Seed',
        weight = 1,
    },

    ['weed_brick'] = {
        label = 'Weed Brick',
        weight = 2000,
    },

    ['weed_nutrition'] = {
        label = 'Plant Fertilizer',
        weight = 2000,
    },

    ['joint'] = {
        label = 'Joint',
        weight = 200,
    },

    ['rolling_paper'] = {
        label = 'Rolling Paper',
        weight = 0,
    },

    ['empty_weed_bag'] = {
        label = 'Empty Weed Bag',
        weight = 0,
    },

    ['firstaid'] = {
        label = 'First Aid',
        weight = 2500,
    },

    ['ifaks'] = {
        label = 'Individual First Aid Kit',
        weight = 2500,
    },

    ['painkillers'] = {
        label = 'Painkillers',
        weight = 400,
    },

    ['firework1'] = {
        label = '2Brothers',
        weight = 1000,
    },

    ['firework2'] = {
        label = 'Poppelers',
        weight = 1000,
    },

    ['firework3'] = {
        label = 'WipeOut',
        weight = 1000,
    },

    ['firework4'] = {
        label = 'Weeping Willow',
        weight = 1000,
    },

    ['steel'] = {
        label = 'Steel',
        weight = 100,
    },

    ['rubber'] = {
        label = 'Rubber',
        weight = 100,
    },

    ['metalscrap'] = {
        label = 'Metal Scrap',
        weight = 100,
    },

    ['iron'] = {
        label = 'Iron',
        weight = 100,
    },

    ['copper'] = {
        label = 'Copper',
        weight = 100,
    },

    ['aluminium'] = {
        label = 'Aluminium',
        weight = 100,
    },

    ['plastic'] = {
        label = 'Plastic',
        weight = 100,
    },

    ['glass'] = {
        label = 'Glass',
        weight = 100,
    },

    ['gatecrack'] = {
        label = 'Gatecrack',
        weight = 1000,
    },

    ['cryptostick'] = {
        label = 'Crypto Stick',
        weight = 100,
    },

    ['trojan_usb'] = {
        label = 'Trojan USB',
        weight = 100,
    },

    ['toaster'] = {
        label = 'Toaster',
        weight = 5000,
    },

    ['small_tv'] = {
        label = 'Small TV',
        weight = 100,
    },

    ['security_card_01'] = {
        label = 'Security Card A',
        weight = 100,
    },

    ['security_card_02'] = {
        label = 'Security Card B',
        weight = 100,
    },

    ['drill'] = {
        label = 'Drill',
        weight = 5000,
    },

    ['thermite'] = {
        label = 'Thermite',
        weight = 1000,
    },

    ['diving_gear'] = {
        label = 'Diving Gear',
        weight = 30000,
    },

    ['diving_fill'] = {
        label = 'Diving Tube',
        weight = 3000,
    },

    ['antipatharia_coral'] = {
        label = 'Antipatharia',
        weight = 1000,
    },

    ['dendrogyra_coral'] = {
        label = 'Dendrogyra',
        weight = 1000,
    },

    ['jerry_can'] = {
        label = 'Jerrycan',
        weight = 3000,
    },

    ['nitrous'] = {
        label = 'Nitrous',
        weight = 1000,
    },

    ['wine'] = {
        label = 'Wine',
        weight = 500,
    },

    ['grape'] = {
        label = 'Grape',
        weight = 10,
    },

    ['grapejuice'] = {
        label = 'Grape Juice',
        weight = 200,
    },

    ['coffee'] = {
        label = 'Coffee',
        weight = 200,
    },

    ['vodka'] = {
        label = 'Vodka',
        weight = 500,
    },

    ['whiskey'] = {
        label = 'Whiskey',
        weight = 200,
    },

    ['beer'] = {
        label = 'Beer',
        weight = 200,
    },

    ['sandwich'] = {
        label = 'Sandwich',
        weight = 200,
    },

    ['walking_stick'] = {
        label = 'Walking Stick',
        weight = 1000,
    },

    ['lighter'] = {
        label = 'Lighter',
        weight = 200,
    },

    ['binoculars'] = {
        label = 'Binoculars',
        weight = 800,
    },

    ['stickynote'] = {
        label = 'Sticky Note',
        weight = 0,
    },

    ['empty_evidence_bag'] = {
        label = 'Empty Evidence Bag',
        weight = 200,
    },

    ['filled_evidence_bag'] = {
        label = 'Filled Evidence Bag',
        weight = 200,
    },

    ['harness'] = {
        label = 'Harness',
        weight = 200,
    },

    ['handcuffs'] = {
        label = 'Handcuffs',
        weight = 200,
    },
}
