import SwiftUI

struct FunFactsModel {
    var facts = [
        FactsModel(birdName: "Classic", fact: [
            Fact(title: "Adaptability", desc: "The classic bird is known for its adaptability to different environments."),
            Fact(title: "Symbolism", desc: "It often symbolizes freedom and courage in various cultures."),
            Fact(title: "Migration", desc: "Classic birds migrate thousands of kilometers each year."),
            Fact(title: "Diet", desc: "Their diet primarily consists of seeds and insects."),
            Fact(title: "Song", desc: "Their melodious song is used to attract mates."),
            Fact(title: "Nesting", desc: "They build nests in sheltered places to protect their young."),
            Fact(title: "Camouflage", desc: "Their feathers provide excellent camouflage in forests."),
            Fact(title: "Lifespan", desc: "They typically live up to 15 years in the wild."),
            Fact(title: "Pollinators", desc: "They play an important role as pollinators in many ecosystems."),
            Fact(title: "Social", desc: "Classic birds often live and travel in flocks.")
        ]),
        FactsModel(birdName: "Chicken", fact: [
            Fact(title: "Domestication", desc: "Chickens were domesticated from wild junglefowl in Southeast Asia."),
            Fact(title: "Vision", desc: "They have excellent vision and can see full color spectrum."),
            Fact(title: "Egg Laying", desc: "Hens can lay around one egg per day in peak season."),
            Fact(title: "Communication", desc: "Chickens communicate through over 30 different calls."),
            Fact(title: "Social Hierarchy", desc: "They establish a ‘pecking order’ in flocks."),
            Fact(title: "Speed", desc: "Chickens can run up to 9 miles per hour."),
            Fact(title: "Lifespan", desc: "The oldest known chicken lived nearly 16 years."),
            Fact(title: "Diet", desc: "They are omnivores, eating seeds, insects, and small reptiles."),
            Fact(title: "Mothering", desc: "Strong maternal instincts protect their chicks."),
            Fact(title: "Research", desc: "Chickens are widely used in scientific studies of behavior.")
        ]),
        FactsModel(birdName: "Turkey", fact: [
            Fact(title: "Origin", desc: "Turkeys are native to North America and were domesticated by Native Americans."),
            Fact(title: "Gobble", desc: "Male turkeys’ gobbles can be heard up to a mile away."),
            Fact(title: "Flight", desc: "Wild turkeys can fly short distances despite their size."),
            Fact(title: "Vision", desc: "They have excellent color vision."),
            Fact(title: "Roosting", desc: "Turkeys roost in trees at night for safety."),
            Fact(title: "Mating", desc: "Males use wattles and snoods to attract mates."),
            Fact(title: "Beard", desc: "The beard is a tuft of coarse hair found on males."),
            Fact(title: "Lifespan", desc: "Wild turkeys live up to 10 years."),
            Fact(title: "Ecology", desc: "They help spread seeds in forest ecosystems."),
            Fact(title: "Breeding", desc: "Turkeys have a complex courtship display.")
        ]),
        FactsModel(birdName: "Parrot", fact: [
            Fact(title: "Intelligence", desc: "Parrots are highly intelligent and can mimic human speech."),
            Fact(title: "Lifespan", desc: "Some parrots live over 60 years."),
            Fact(title: "Diet", desc: "They eat seeds, nuts, fruit, and sometimes insects."),
            Fact(title: "Flight", desc: "Many species are excellent fliers."),
            Fact(title: "Social", desc: "Parrots are social birds often living in flocks."),
            Fact(title: "Colors", desc: "They have bright, colorful plumage."),
            Fact(title: "Beak", desc: "Strong curved beaks help crack nuts."),
            Fact(title: "Habitat", desc: "Found mostly in tropical and subtropical regions."),
            Fact(title: "Reproduction", desc: "Parrots form strong pair bonds."),
            Fact(title: "Conservation", desc: "Many species are threatened due to habitat loss.")
        ]),
        FactsModel(birdName: "Canary", fact: [
            Fact(title: "Singing", desc: "Canaries are famous for their beautiful singing."),
            Fact(title: "Domestication", desc: "They were domesticated in the 17th century."),
            Fact(title: "Colors", desc: "Canaries come in yellow, orange, white, and red."),
            Fact(title: "Diet", desc: "Their diet includes seeds and fresh greens."),
            Fact(title: "Flight", desc: "Canaries are good fliers."),
            Fact(title: "Social", desc: "They are social but fight during breeding season."),
            Fact(title: "Breeding", desc: "Females build cup shaped nests."),
            Fact(title: "Lifespan", desc: "Typical lifespan is 10 years."),
            Fact(title: "Habitat", desc: "Natively from Canary Islands, Azores, Madeira."),
            Fact(title: "Use", desc: "Historically used in coal mines to detect toxic gases.")
        ]),
        FactsModel(birdName: "Penguin", fact: [
            Fact(title: "Flightless", desc: "Penguins are birds that cannot fly."),
            Fact(title: "Swimming", desc: "They are excellent swimmers and divers."),
            Fact(title: "Habitat", desc: "Primarily live in southern hemisphere, Antarctica."),
            Fact(title: "Social", desc: "Live in large colonies."),
            Fact(title: "Diet", desc: "Eat fish, squid, and krill."),
            Fact(title: "Adaptation", desc: "Have thick layers of fat and waterproof feathers."),
            Fact(title: "Breeding", desc: "Lay eggs on land or ice."),
            Fact(title: "Communication", desc: "Use unique calls to identify mates."),
            Fact(title: "Endurance", desc: "Can dive hundreds of meters deep."),
            Fact(title: "Predators", desc: "Threatened by seals, orcas, and humans.")
        ]),
        FactsModel(birdName: "Flamingo", fact: [
            Fact(title: "Feeding", desc: "Feed with their head upside down."),
            Fact(title: "Color", desc: "Pink coloration comes from carotenoid pigments in diet."),
            Fact(title: "Habitat", desc: "Live in lagoons and large saline or alkaline lakes."),
            Fact(title: "Social", desc: "Live in large flocks."),
            Fact(title: "Height", desc: "Can stand over 4 feet tall."),
            Fact(title: "Weight", desc: "Females are typically lighter than males."),
            Fact(title: "Flight", desc: "Strong flyers, can travel long distances."),
            Fact(title: "Nesting", desc: "Make mud nests to raise chicks."),
            Fact(title: "Lifespan", desc: "Can live up to 30 years."),
            Fact(title: "Behavior", desc: "Known for standing on one leg.")
        ]),
        FactsModel(birdName: "Peacock", fact: [
            Fact(title: "Display", desc: "Male peacocks display vibrant tail feathers."),
            Fact(title: "Colors", desc: "Tail feathers have iridescent blue and green colors."),
            Fact(title: "Courtship", desc: "Use fan display to attract females."),
            Fact(title: "Sound", desc: "Make loud calls during mating season."),
            Fact(title: "Size", desc: "Can grow up to 8 feet with tail spread."),
            Fact(title: "Habitat", desc: "Native to India and Sri Lanka."),
            Fact(title: "Diet", desc: "Eat seeds, insects, and small reptiles."),
            Fact(title: "Flight", desc: "Can fly short distances."),
            Fact(title: "Lifespan", desc: "Live approximately 15-20 years."),
            Fact(title: "Symbolism", desc: "Symbols of beauty and immortality in many cultures.")
        ]),
        FactsModel(birdName: "Toucan", fact: [
            Fact(title: "Beak", desc: "Large colorful beaks that are lightweight."),
            Fact(title: "Size", desc: "Small to medium-sized birds."),
            Fact(title: "Habitat", desc: "Live in tropical forests in Central and South America."),
            Fact(title: "Diet", desc: "Eat fruit, insects, and small reptiles."),
            Fact(title: "Flight", desc: "Short-distance fliers."),
            Fact(title: "Social", desc: "Live in small flocks."),
            Fact(title: "Nesting", desc: "Nest in tree cavities."),
            Fact(title: "Communication", desc: "Make loud croaking calls."),
            Fact(title: "Lifespan", desc: "Up to 20 years in the wild."),
            Fact(title: "Conservation", desc: "Some species are threatened or endangered.")
        ]),
        FactsModel(birdName: "Owl", fact: [
            Fact(title: "Nocturnal", desc: "Owls are mostly active at night."),
            Fact(title: "Hearing", desc: "Have exceptional hearing for hunting."),
            Fact(title: "Vision", desc: "Can rotate heads almost 360 degrees."),
            Fact(title: "Diet", desc: "Eat rodents, insects, and small birds."),
            Fact(title: "Silent Flight", desc: "Feathers allow silent flight."),
            Fact(title: "Habitat", desc: "Found worldwide in various habitats."),
            Fact(title: "Camouflage", desc: "Feathers provide excellent camouflage."),
            Fact(title: "Lifespan", desc: "Live about 4-10 years in the wild."),
            Fact(title: "Reproduction", desc: "Build nests in tree hollows or abandoned nests."),
            Fact(title: "Symbolism", desc: "Often symbolizes wisdom and mystery.")
        ]),
        FactsModel(birdName: "Pigeon", fact: [
            Fact(title: "Feral", desc: "Pigeons have adapted to city life worldwide."),
            Fact(title: "Navigation", desc: "Excellent homing ability."),
            Fact(title: "Communication", desc: "Coos are used to attract mates."),
            Fact(title: "Diet", desc: "Eat seeds, fruits, and human scraps."),
            Fact(title: "Breeding", desc: "Mate for life and build simple nests."),
            Fact(title: "Flight", desc: "Strong flyers and fast."),
            Fact(title: "Lifespan", desc: "Can live up to 20 years."),
            Fact(title: "Intelligence", desc: "Can recognize themselves in mirrors."),
            Fact(title: "Uses", desc: "Used in messenger services historically."),
            Fact(title: "Cultural", desc: "Symbols of peace and love.")
        ]),
        FactsModel(birdName: "Seagull", fact: [
            Fact(title: "Habitat", desc: "Seagulls are coastal birds."),
            Fact(title: "Diet", desc: "Omnivorous, eat fish, insects, and garbage."),
            Fact(title: "Social", desc: "Often form large colonies."),
            Fact(title: "Flight", desc: "Strong, soaring flight abilities."),
            Fact(title: "Nesting", desc: "Nest on cliffs and beaches."),
            Fact(title: "Communication", desc: "Loud, high-pitched calls."),
            Fact(title: "Adaptability", desc: "Can thrive in urban areas."),
            Fact(title: "Lifespan", desc: "Live around 10-15 years."),
            Fact(title: "Behavior", desc: "Known for stealing food."),
            Fact(title: "Intelligence", desc: "Problem solvers and tool users.")
        ])
    ]

}


