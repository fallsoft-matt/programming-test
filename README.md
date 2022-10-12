# Weather Report (Programming Test)

## Time Spent
I started this project on Monday morning and spent about 16 hours coding 

## Design Choices
I decided to go for a more complex and time consuming solution considering that I'm applying to a senior role. 

Instead of building something quickly by storing the Data as JSON, I went with a CoreData solution (which I'm admittedly a little new to)

Additionally, I built out the "Weather Services" folder as if it were a seperate library, using appropriate access control (public, internal private). The async service class is probably a little overkill for a project this small, but it is definitely something I'd want for a larger codebase. 

For a larger project, I'd also have the networking done in such a way as to abstract away Alamofire (and the network code would also go in a seperate library).

## References and Third Party Libraries

For extra libraries, I've only added Alamofire via Xcode's built in package manager.

Here is a brief list of references I consulted while working on the project: 

https://medium.com/ios-os-x-development/10-core-principles-to-use-coredata-without-blowing-your-head-off-5ed11c623c6b

https://developer.apple.com/documentation/coredata/modeling_data/configuring_entities

https://docs.swift.org/swift-book/LanguageGuide/Concurrency.html

https://stackoverflow.com/questions/57744812/how-to-trigger-uicontextmenuinteraction-context-menu-programmatically

## Known Issues
A few issues I'd like to to highlight:
1. Error messages are not specific to the type of Error

2. I've done no localization, testing with smaller screens,  accessibility etc...

3. I decided against using / displaying cloud information (as well as a few other data points) strictly in the interest of time 

## Closing
This was a super fun test to knock out; I greatly enjoyed looking at the raw data from various airports I frequent (KORL, KRQB).

I also wanted to say that the JSON object returned from the endpoint seemed really well designed, so I wanted to give a shout out to whoever had a hand in that. 
