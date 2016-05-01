---
layout: post
title: On pairing
---

I never did XP style pairing until I arrived in London. My experience
had been mostly solo work, with plenty of team collaboration, and some rare
pairing on tough problems. I was pretty excited about trying something
new. And it's part of why I picked my first role in London.

# Pairing for the first time

That first day of pairing was one of the worst days in my professional life.
I wasn't allowed to touch the keyboard, I had no idea what was
going on, the project was years in the making and complex.
And I was expected to pair successfully with this guy on day 1. He wasn't
particularly interested in explaining the code to me. I had
the distinct impression he felt I was slowing him down, and he wanted to
minimize my impact on his _velocity_. I sat there, overwhelmed with
the depressing situation of it all, and started counting minutes until I
got home, for the first time in my career.

# What doesn't kill you...

I got over this episode, and I even managed to contribute significantly
to that project. I even got the hang of pairing and started to enjoy it.
But this first impression really stuck in my mind. Pairing is downright
_hell_ in the wrong hands. But I'm getting ahead of myself.

A few things went wrong that day. Pairing, as Kent Beck described it,
is meant to be done between peers with similar amounts of knowledge.
I had no on-boarding or mentoring as a new joiner. My first pairing partner
was not good at pairing and had no interest in being so. This person
really should not have been working in a pairing environment, or been
assigned to work with me initially.

Pairing is fundamentally different to working solo. Actively interacting
with another person while trying to think deeply about an engineering
problem relies on a whole set of brain muscles that I wasn't used to
using. I like to think of it as _social coding_.

Fortunately, it didn't take me long to learn what good pairing felt like,
as there were some good people there. It took me probably 6 months to
really get the hang of it.

# The cargo cult is strong

Pair programming is very popular in London. If you're from the USA,
you'll probably find it a bit shocking unless you've worked at one of
the companies that pair all the time. It's probably more difficult
to find a job that doesn't require pairing.

I wouldn't mind this so much, except that I think pairing is hard to get
right. And it's much worse for individuals when it goes wrong. It is
torture to sit and watch someone work while doing nothing for 8
hours. I've been on both sides of this. On the receiving end when I'm
new to a team. And doing it when I've been on a team for a while.

Although I try very hard when I realize the other person is not
engaging, it's not always enough. A good chunk of engineers have
social anxiety of some form, and it takes time to gel.
The worst situation is when you don't gel with a team, and then
pairing can become daily torture.

An interesting thing about pair programming is it's one of those few XP 
engineering practices which has been well studied. And the studies
all tend to show little to no benefit, or a negative benefit, at 
increased cost.[^1] So why does the cult stick around?

# So you want to do it right?

I believe pair programming can be done right, although it's not easy. I
think many groups who use it feel like it's a way of completely
removing process. Just pair and commit directly to master. It's
continuous code review. We don't need to talk beyond daily pairing
interaction.

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

Accept that not all tasks are ideal to be paired on. For research and
learning, it can make sense to split up and do research independently.

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
