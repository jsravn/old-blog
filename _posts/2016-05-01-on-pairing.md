---
layout: post
title: On pairing
---

I never did XP style pairing until I arrived in London. My experience
had been mostly solo work, with plenty of team collaboration, and some rare
pairing on tough problems. I was pretty excited about trying something
new. And it's part of why I picked my first role in London.

# Pairing for the first time

That first day of pairing was pretty bad. It was a complex
codebase that was years in the making. The person I paired with,
a consultant, wasn't interested in explaining things to me or
letting me touch the keyboard. It was a very frustrating experience.
I'm used to diving into new codebases and picking up things quickly.
Instead, I just sat there unable to contribute much, counting
down the minutes until the day ended.

# What doesn't kill you...

I eventually got the hang of pairing and started to enjoy it.
That first impression really stuck in my mind though. Pairing can be
downright awful when done poorly.

A few things went wrong that day. Pairing, as I understand it,
is meant to be done between peers with similar amounts of knowledge.
I had no on-boarding or mentoring as a new joiner. My first pairing partner
was not good at pairing and didn't have much interest in being so. This person
really should not have been working in a pairing environment, or been
assigned to work with me initially.

Pairing is fundamentally different to working solo. Actively interacting
with another person while trying to think deeply about an engineering
problem relies on a whole set of brain muscles that I wasn't used to
using. I like to think of it as _social coding_.

Fortunately, there were some good people there, so I was able to develop
an idea of what good pairing felt like. It took me probably 6 months to
really get the hang of it.

# The cargo cult is strong

Pair programming is very popular in London. If you're from the USA,
you'll probably find it a bit shocking unless you've worked at one of
the companies that pair all the time. It's probably more difficult
to find a job that doesn't require pairing.

I wouldn't mind this so much, except that I think pairing is hard to get
right, and there really isn't a convention on the right way to do it.
And it's much worse for individuals when it goes wrong. It is
torture to sit and watch someone work while doing nothing for 8
hours. I've been on both sides of this. On the receiving end when I'm
new to a team. And doing it when I've been on a team for a while. When
experience levels are too different, it's very hard for the other
person to contribute meaningfully.

Although I try very hard when I realize the other person is not
engaging, it's not always enough. A good chunk of engineers have
social anxiety of some form, and it takes time to gel. It also
simply takes time for the person to come up to speed and understand
the project.

An interesting thing about pair programming is it's one of those few XP 
engineering practices which has been well studied. And the studies
all tend to show little to no benefit, or a negative benefit, at 
increased cost.[^1] So why does the cult stick around?

# So you want to do it right?

I believe pair programming can be done right, although it's not easy. I
think many groups who use it feel like it's a way of completely
removing process. Just pair and commit directly to master. It's
continuous code review. We don't need any documentation. And so on.

This misses the costs of pairing that need extra attention. Social,
in-person interaction between team members becomes more crucial. It's
now part of the critical path of all code commits, even key presses.
This requires a manager skilled in building people's personal skills and
resolving conflicts in teams. This is important in any team, but I think even
more so in a team of 100% pairing.

Another thing is ownership. Pairing seems to naturally de-emphasize
individual ownership and responsibility. Many teams that pair will rotate
at least daily on tasks. It's hard to feel ownership of a task when
you only spend a day on it, then move to the next thing. I've seen
tasks go astray, a bit like the game where a message gets
passed from kid to kid by ear in a circle. I suggest keeping changes
to less than day of work, which should include it going to production.
For tasks longer, I suggest one person stays on the task and owns it -
they are responsible for stewarding that change to production and
on-boarding new pair partners.

External interaction can be tricky in a team that pairs. It's difficult
to read your github feed/emails/chat when pairing. All focus is on the social
interaction of pairing. If your team supports external clients, I suggest
having a solo support role that rotates and can respond without having
to break the pairing flow.

Accept that not all tasks are ideal to be paired on. 
It can be difficult to write up a detailed design doc as a pair.
For research and learning, it can make sense to split up and do
research independently.

People also learn differently. Ask newcomers how they learn best. Some
people would prefer to spend time on their own to get up to speed. When
they are ready, you can incorporate them into the pair rotation. Or
if they prefer mentorship, assign a dedicated mentor for the first few
weeks until they are comfortable.

And finally, pair programming is exhausting. I believe Kent Beck
claims in the XP book he doesn't pair for more than 6 hours a day. My
first pairing experience was 8 hours without many breaks. It was tiring!
Accept that your developers will have to take more breaks and work less
hours when pairing. That's the cost of it. Alternatively, consider a day
off a week from pairing.

# It's just a different way of working

It annoys me when people claim pair programming is superior to anything
else. The empirical evidence shows no obvious superiority. Outside
of the microcosm of London IT, I think it's an oddity more than the norm.

Choose to pair if it suits your team, not because you think it's the
silver bullet of software engineering.

***

[^1]: <http://www.sciencedirect.com/science/article/pii/S0950584909000123>
