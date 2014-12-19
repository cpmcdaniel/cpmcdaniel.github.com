---
layout: post
title: Data Models vs Data Abstractions
---

The landscape of programming is changing. Are your tools ready? As the days of 
vertically-scalable PC systems has come to an end (it's been awhile, but some 
still haven't noticed), the world of multicore, cloud computing, and mobile 
has taken over. Smart phones and social media have created an explosion of 
data volume, much of which is unstructured and in an ever-increasing variety 
of shapes and formats.

# It's all about the data...

> It is better to have 100 functions operate on one data structure than 10 
> functions on 10 data structures. <br />
> - Alan Perlis

This quote by Alan Perlis is demonstrated well in the LISP language and its 
variants (including [Clojure](http://www.clojure.org/)). These languages 
provide a Swiss Army knife of functions for working with *lists* (or more 
generally, *sequences*). Since we are rarely dealing with just one piece of 
data, but rather multiple *records*, we can accomplish quite a lot with this
simple data *abstraction* and the functions that operate on it. This gives us
much more power and general-purpose utility than any special-purpose data 
structure. 

To put this into terms that Java/C# developers can relate to, imagine if 
*ArrayList* and *LinkedList* did *not* implement the *List* interface. Each 
data structure would require its own set of methods for working with only that
type of object. Without the *List* abstraction, we could not write generic code
for handling both types. Why, then, do we not typically apply the same 
principle to our data models? 

# Your Classes are Proprietary

> The prevailing form of programming today, object orientation, is generally 
> hostile to data. Its focus on behavior wraps up data in access methods, and
> wraps up collections of data even more tightly. In the mathematical world,
> *data just is*, it has no behavior, yet the rigors of C++ or Java require 
> developers to worry about how it is accessed. <br />
> - Ed Dumbill, [The future of programming](http://radar.oreilly.com/2013/01/the-future-of-programming.html)

Idiomatic Java/C# development would have our data enshrined in classes which 
model things in the real world. So we take our data and trap it (or 
*encapsulate* it, if you prefer) inside its own proprietary micro-API. We assume 
this is a good thing for several compelling reasons: compile-time static 
type-checking, code completion, and a small amount of self-documenting 
structure. Of these, only the last is of significant value, as you should be 
testing and exercising your code often, not relying on your IDE and compiler to
give you a false sense of safety. Be honest. We've all felt really good when we
get a clean compile, only to run it and have a silly (non-type-related) bug 
bring us crashing back down to reality. The allure of proprietary classes for 
your data is like a siren, wooing you and your shipmates toward a rocky demise.

# How Many Person Classes Have You Written?

The answer - probably as many as you've had applications that needed to 
represent people as data entities. Any code written against this class is not
portable or reusable outside of your system. This might not matter to you, but 
it can even be a barrier to reuse *within* your own application. How so? 

Let's take an example. Assume we have two database tables, PERSON and PRODUCT.
Your mission, should you choose to accept it, is to extract the data from these 
tables into CSV files. With the proliferation of ORMs (Hibernate, anyone?) and 
DTO patterns, most Java developers will immediately reach for the following
object model (or something similar):

{% highlight java linenos %}
public class Person {
	private int personId;
	private String firstName;
	private String lastName;
	private Date dateOfBirth;
	// getter and setter barf omitted.
}

public class Product {
	private int productId;
	private String name;
	private double unitPrice;
	// getter and setter barf omitted.
}
{% endhighlight %}

You would then proceed along the following for each table/type:

1. Query the appropriate table.
2. Transform each row in the result set into a Person/Product.
3. Transform each Person/Product into a line in the CSV.

If you see the problem with this, you win a prize! There are actually two 
problems: you have to do 2 transformations, and then you have to do this for 
each class. If you have N classes in your data model, you will have to 
write code like this N times. Now, lets add a new wrinkle: we also want to make
Person and Product records available as JSON for a web front-end. Again, the 
amount of code and repetition multiplies, and is it really all for the sake of 
developer convenience and type safety? 

I have been on so many Java projects like this that I swear it is considered 
idiomatic "best practice" by the community. We love our tasty beans. I would 
estimate that north of 70% of the code in these applications is nothing but 
[anemic domain model](http://www.martinfowler.com/bliki/AnemicDomainModel.html)
and transformation code to-and-from generic data formats like JDBC ResultSet 
and CSV/JSON. Why not just write one utility that exports any ResultSet as CSV
or JSON and be done with it? Obviously, not every use case is this vanilla, but 
I hope you can see the explosive potential of proprietary data models.

Generic Data in Java/C#
=======================

> I think the real root of the problem is that the OO community focuses so much
> on abstracting *behavior*, they forget to abstract their *data*.

Of course, there is nothing stopping you from doing this. Or is there?

## Alternatives

### 1. I know, just use Maps and Lists instead of custom models!!!
Maybe, but then you lose your beloved code completion and self-documenting 
structure, not to mention that working with Maps and Lists in Java is 
relatively painful and verbose (it is definitely hostile toward generic data).

### 2. Use reflection.
Ummm, gross. Hardly readable. While used effectively in APIs and frameworks, you
rarely see application developers processing objects with reflection - probably
for good reason!

Both of these approaches suffer from a common and critical flaw - the industry 
doesn't do OOP this way. It's not idiomatic. Write an entire application this way
and whoever takes over the project will definitely want to rewrite it.

# Recommendation

Java and C# simply aren't the right tools for today's landscape of data. To effectively
wrangle this, you need tools that embrace generic data structures. If you feel like you
can't breathe without static typing, take a look at Scala. You still need to watch out
for the explosion of transform code around any custom data models you create, but at
least you have a language that is not hostile to generic data structures.

Of course, my preference is Clojure for both its simplicity and the power of its 
sequence abstraction. I am rarely tempted to "trap" my data, as the language features
naturally steer you away from such foolishness. Free your data!

