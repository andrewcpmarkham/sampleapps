//
//  QuestionData.swift
//  DateNight
//
//  Created by Andrew CP Markham on 9/6/20.
//  Copyright © 2020 Xercise Pro. All rights reserved.
//

import Foundation

struct Question{
    var text: String
    var questionType: QuestionType
    var answers: [Answer]
    
    mutating func shuffleAnswers(){
        
        if questionType != .ranged{//no point in changing ranged answers
            answers = answers.shuffled()
        }
        
    }
}

enum QuestionType{
    case single, multiple, ranged
}

enum Activity{
    case resturant, movie
}

class Answer {
    var text: String
    
    init(text: String) {
        self.text = text
    }
    
    /*
     @Navdeep: Acknowledging your comment from last assignment
     It seems easier to take advantage of inheritance here,
     for simplicty of code sake with little consequences to performance
     Hence class's over structs have been applied
     Respect though that structs are the usual preference.
     */
}

//Resturant Answer
class RestaurantAnswer: Answer {
    var restaurantType: [Resturant]
    
    init(text: String, restaurantType: [Resturant]) {
        self.restaurantType = restaurantType
        super.init(text: text)
    }
}

enum Resturant{
    case restaurant1, restaurant2, restaurant3, restaurant4, restaurant5, restaurant6, restaurant7, restaurant8,
    restaurant9, restaurant10, restaurant11, restaurant12, restaurant13, restaurant14, restaurant15, restaurant16

    var definition: [String]{
        switch self{
            
        //Eat In Prepared
        case .restaurant1:
            return ["The Dog Hotel", "Comfort food and craft beer on tap in a spacious, stylish corner pub with a leafy beer garden.", "2 St Marks Rd, Randwick NSW 2031", "(02) 9398 2682", "restaurant1.jpeg"]
        case .restaurant2:
            return ["Signorelli Gastronomia", "Multipurpose venue with a buzzy Italian restaurant, an artisanal produce shop and cooking classes.", "Trouton Pl, Pyrmont NSW 2009", "(02) 8571 0616", "restaurant2.jpeg"]
        case .restaurant3:
            return ["Danjee", "Upscale Korean mains, plus BBQ dishes & share plates, presented in a bright, modern dining room.", "1-7 Albion Pl, Sydney NSW 2000", "(02) 8084 9041", "restaurant3.jpeg"]
        case .restaurant4:
            return ["678 Korean BBQ", "A delicious korean restaurant serving Sydney", "Level 1, 396 Pitt Street, corner Goulburn Street, Haymarket, Sydney", "(02) 9281 8997", "restaurant4.jpeg"]
        //Eat In Cooked
        case .restaurant5:
            return ["Cafe Sydney", "A rooftop restaurant with sweeping harbour views serving Modern Australian cuisine and cocktails.", "5 Sydney Customs House, 31 Alfred St, Sydney NSW ", "(02) 9251 8683", "restaurant5.jpeg"]
        case .restaurant6:
            return ["Fratelli Fresh", "Fratelli Fresh serves much - loved, authentic Italian cuisine in Sydney", "11 Bridge St, Sydney NSW 2000", "(02) 9259 5692", "restaurant6.jpeg"]
        case .restaurant7:
            return ["Mr. Wong", "Modern Cantonese menu, from dim sum to classic mud crab, served in a lavish French-colonial setting.", "3 Bridge Ln, Sydney NSW 2000", "(02) 9114 7317", "restaurant7.jpeg"]
        case .restaurant8:
            return ["Sydney Madang Korean BBQ Restaurant", "Airy and bright Korean restaurant with laid-back vibe, for BBQ dishes and mains, with BYO alcohol.", "371A Pitt St, Sydney NSW 2000", "(02) 9264 7010", "restaurant8.jpeg"]
        //Delivery Prepared
        case .restaurant9:
            return ["Gourmet Dinner Service", "Convenient delicious chef created meals.", "5/9 Powells Rd, Brookvale NSW 2100", "(02) 9905 0266", "restaurant9.jpeg"]
        case .restaurant10:
            return ["The Grounds of Alexandria", "Homestyle food and specialty coffee in a former pie factory with brick walls and an organic garden.", "7a/2 Huntley St, Alexandria NSW 2015", "(02) 9699 2225", "restaurant10.jpeg"]
        case .restaurant11:
            return ["Rice Bowl Home Delivery Chinese Meals", "Chineese meals prepared ready for use at your convenience.", "41 Hall Dr, Menai NSW 2234", "(02) 9543 6777", "restaurant11.jpeg"]
        case .restaurant12:
            return ["Sang by Mabasa", "Our focus is to present authentic flavours with a contemporary viewing.", "98 Fitzroy St, Surry Hills NSW 2010", "(02) 9331 5175", "restaurant12.jpeg"]
        //Delivery Cooked
        case .restaurant13:
            return ["Blackbird Cafe", "Modern Australian food in a huge, vibrant space with a central bar, yellow chairs and a balcony.", "Wheat Road Balcony Level 1, Cockle Bay Wharf Darling Harbour, NSW 2000", "(02) 9283 7385", "restaurant13.jpeg"]
        case .restaurant14:
            return ["Crust Pizza", "Our mission is to make pizza to feed all of your senses.", "208 Harris St, Pyrmont NSW 2009", "(02) 9566 1933", "restaurant14.jpeg"]
        case .restaurant15:
            return ["Lotus Dumpling Bar", "Pan-Asian dishes, dumplings and cocktails in a space with exposed-brick walls and copper details.", "Shop 3/16 Hickson Rd, Dawes Point NSW 2000", "(02) 9251 8328", "restaurant15.jpeg"]
        case .restaurant16:
            return ["Seoul Project", "At Seoul Project there are Korean offerings but there is also a range of Korean tacos and quesadillas fusing Korean and Mexican cuisines.", "9 Wilmot St, Sydney NSW 2000", "(02) 9261 2296", "restaurant16.jpeg"]
        }
    }
}

//Movie Answer
class MovieAnswer: Answer{
    var movieType: [Movie]
    
    init(text: String, movieType: [Movie]) {
        self.movieType = movieType
        super.init(text: text)
    }
}

enum Movie{
    case movie1 , movie2, movie3, movie4, movie5, movie6, movie7, movie8,
    movie9, movie10, movie11, movie12, movie13, movie14, movie15, movie16
    
    var definition: [String]{
        switch self{
        //Action
        case .movie1:
            return ["BloodShot", "Bloodshot is a trash compactor of a comic-book film, but it's smart trash, an action matrix that's fun to plug into.", "movie1"]
        case .movie2:
            return ["The Gentlemen", "Guy Ritchie makes a very Guy Ritchie movie, this time with Matthew McConaughey, Hugh Grant and Charlie Hunnam.", "movie2"]
        case .movie3:
            return ["Hobbs & Shaw", "This high-spirited summer action extravaganza delivers precisely what it promises: two great personalities, great stunts, and a little something extra.", "movie3"]
        case .movie4:
            return ["John Wick 3", "This third entry in the over-the-top action series gets more complicated, with lots more explanation -- but the bracingly crisp, fluid fight choreography still blows away most challengers.", "movie4"]
        //Comedy
        case .movie5:
            return ["Bad Boys For Life", "Not so much bad Bad Boys, more good Bad Boys. And not so-bad-it’s-good Bad Boys either. Instead, this is comfortably the best entry in the series to date. Which isn’t bad.", "movie5"]
        case .movie6:
            return ["Jumanji - The Next Level", "The return of the likable core cast and the addition of DeVito, Glover, and Awkwafina make this sequel an entertaining twist on the original -- and surprisingly funnier than expected.", "movie6"]
        case .movie7:
            return ["Night School", "Haddish and Hart are a comedic dream team: Her blunt, oh-no-you-didn't style is the perfect foil for Hart's brand of \"let me explain\" humor.", "movie7"]
        case .movie8:
            return ["Oceans 8", "Bullock, Blanchett, and their co-stars don't reinvent George Clooney's formula here, but the ensemble's camaraderie and notable talents make for a fun heist flick that combines fashion and humor.", "movie8"]
        //Romantic
        case .movie9:
            return ["Longshot", "Long Shot is everything you'd expect from an R-rated comedy starring Seth Rogen.", "movie9"]
        case .movie10:
            return ["PS I Love You", "P.S. I Love You looks squeaky clean and utterly straight. Yet as directed by Richard LaGravenese, it has a curious morbid quality.", "movie10"]
        case .movie11:
            return ["A star is born", "Bradley Cooper, who directed and stars with Lady Gaga, creates thrills with a steadfast belief in old-fashioned, big-feeling cinema.", "movie11"]
        case .movie12:
            return ["About Time", "Ultimately, the message is simple and visceral enough to have crossover appeal. Give it a shot if romantic comedies float your boat.", "movie12"]
        //Thriller
        case .movie13:
            return ["The Invisable Man", "More than the screenplay, it's the direction, treatment, superb camerawork and credibly underlined performance from the leading lady that helps work up some shivers here!", "movie13"]
        case .movie14:
            return ["Underwater", "Every claustrophobic space and apocalyptic crash of water registers as a slick visual trigger, yet it's all built on top of a dramatic void. It's boredom in Sensurround.", "movie14"]
        case .movie15:
            return ["Escape Room", "Escape Room is a psychological thriller about six strangers who find themselves in circumstances beyond their control and must use their wits to find the clues or die.", "movie15"]
        case .movie16:
            return ["Joker", "A grim, shallow, distractingly derivative homage to 1970s movies at their grittiest, ?Joker? continues the dubious darker-is-deeper tradition.", "movie16"]
        }
    }
}

var restaurantQuestions: [Question] = [
    Question(text: "How would you like to dine?",
             questionType: .single,
             answers: [
                RestaurantAnswer(text: "Eat In - Cook your own", restaurantType: [.restaurant1, .restaurant2, .restaurant3, .restaurant4]),
                RestaurantAnswer(text: "Eat In - Full Dining", restaurantType: [.restaurant5, .restaurant6, .restaurant7, .restaurant8]),
                RestaurantAnswer(text: "Delivery - Cook your own", restaurantType: [.restaurant9, .restaurant10, .restaurant11, .restaurant12]),
                RestaurantAnswer(text: "TakeAway", restaurantType: [.restaurant13, .restaurant14, .restaurant15, .restaurant16])
        ]),
    Question(text: "What cuisine are you after?",
             questionType: .multiple,
             answers: [
                RestaurantAnswer(text: "Modern Australian", restaurantType: [.restaurant1, .restaurant5, .restaurant9, .restaurant13]),
                RestaurantAnswer(text: "Italian", restaurantType: [.restaurant2, .restaurant6, .restaurant10, .restaurant14]),
                RestaurantAnswer(text: "Chinese", restaurantType: [.restaurant3, .restaurant7, .restaurant11, .restaurant15]),
                RestaurantAnswer(text: "Korean", restaurantType: [.restaurant4, .restaurant8, .restaurant12, .restaurant16])
        ]),
        Question(text: "Please indicate any dietry requirements?",
                 questionType: .multiple,
                 answers: [
                    RestaurantAnswer(text: "Nut Free", restaurantType: [.restaurant1, .restaurant2, .restaurant5, .restaurant6, .restaurant9, .restaurant10, .restaurant13, .restaurant14]),
                    RestaurantAnswer(text: "Gluten Free", restaurantType: [.restaurant1, .restaurant4, .restaurant5, .restaurant8, .restaurant9, .restaurant12,.restaurant13, .restaurant16]),
                    RestaurantAnswer(text: "Vegetarian", restaurantType: [.restaurant1, .restaurant2, .restaurant3, .restaurant4, .restaurant5, .restaurant6, .restaurant7, .restaurant8, .restaurant9, .restaurant10, .restaurant11, .restaurant12, .restaurant13, .restaurant14, .restaurant15, .restaurant16]),
                    RestaurantAnswer(text: "Vegan", restaurantType: [.restaurant1, .restaurant6, .restaurant9, .restaurant13])
            ]),
            Question(text: "Please indicate a price point?",
                     questionType: .ranged,
                     answers: [
                        RestaurantAnswer(text: "Cheap", restaurantType: [.restaurant1, .restaurant5, .restaurant9, .restaurant13]),
                        RestaurantAnswer(text: "Budget", restaurantType: [.restaurant2, .restaurant6, .restaurant10, .restaurant14]),
                        RestaurantAnswer(text: "Affordable", restaurantType: [.restaurant3, .restaurant7, .restaurant11, .restaurant15]),
                        RestaurantAnswer(text: "Fine Dining", restaurantType: [.restaurant4, .restaurant8, .restaurant12, .restaurant16])
                ])

]


let movieQuestions: [Question] = [
    Question(text: "What atmosphere would you like to watch the movie in?",
             questionType: .single,
             answers: [
                MovieAnswer(text: "Cinema", movieType: [.movie1, .movie5, .movie9, .movie13]),
                MovieAnswer(text: "Open Air Cinema", movieType: [.movie2, .movie6, .movie10, .movie14]),
                MovieAnswer(text: "Drive In", movieType: [.movie3, .movie7, .movie11, .movie15]),
                MovieAnswer(text: "Home Theatre", movieType: [.movie4, .movie8, .movie12, .movie16])
        ]),
    Question(text: "What genre of movie are you after?",
             questionType: .multiple,
             answers: [
                MovieAnswer(text: "Action", movieType: [.movie1, .movie2, .movie3, .movie4]),
                MovieAnswer(text: "Comedy", movieType: [.movie5, .movie6, .movie7, .movie8]),
                MovieAnswer(text: "Romantic", movieType: [.movie9, .movie10, .movie11, .movie12]),
                MovieAnswer(text: "Thriller", movieType: [.movie13, .movie14, .movie15, .movie16])
        ]),
        Question(text: "Please indicate any staring actors/actress's?",
                 questionType: .multiple,
                 answers: [
                    MovieAnswer(text: "Will Smith", movieType: [.movie5]),
                    MovieAnswer(text: "Matthew McConaughey", movieType: [.movie2]),
                    MovieAnswer(text: "Sandra Bullock", movieType: [.movie8]),
                    MovieAnswer(text: "Kristen Stewart", movieType: [.movie14])
            ]),
            Question(text: "Please indicate a preffered rating?",
                     questionType: .ranged,
                     answers: [
                        MovieAnswer(text: "1 Star", movieType: [.movie1, .movie5, .movie9, .movie13]),
                        MovieAnswer(text: "2 Star", movieType: [.movie2, .movie6, .movie10, .movie14]),
                        MovieAnswer(text: "3 Star", movieType: [.movie3, .movie7, .movie11, .movie15]),
                        MovieAnswer(text: "4 Star", movieType: [.movie4, .movie8, .movie12, .movie16])
                ])

]

