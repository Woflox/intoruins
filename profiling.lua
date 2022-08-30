function profileframestart()
    profiled={}
    profilet={}
end

function profile(label)
    if not profiled[label] then
        profiled[label] = {0,0}
    end
    profilet[label]=stat(1)
end

function profileend(label)
    profiled[label][1]+=1
    profiled[label][2]+=stat(1)-profilet[label]
end

function profileprint()
    cursor()
    for k,v in pairs(profiled) do
        ?k.." -- calls:"..v[1].." t:"..v[2]
    end
end