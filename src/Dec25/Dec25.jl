module Dec25

function loopsize(target)
    i = 0
    x = 1
    while x != target
        x = loop(x, 7)
        i += 1
    end
    i
end

loop(x, n) = (x*n) % 20201227

function encryption_key(n, loopsize)
    x = 1
    for i in 1:loopsize
        x = loop(x, n)
    end
    x


end

end

#card = 10441485
#door = 1004920
#encryption_key(door, loopsize(card))


