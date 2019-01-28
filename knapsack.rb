#初期設定
weight = Array.new(50)
value = Array.new(50)
for i in 0..49
  weight[i] = rand(20)+1
  value[i] = rand(10)+1
end

ele = Array.new(20)
for i in 0..19
  ele[i]= Array.new(50)
  for j in 0..49
    ele[i][j]=rand(2)
  end
end

#初期設定出力
puts "50個の品物をランダムに生成"
puts "容量："
puts weight
puts "価値："
puts value

gene = 500
for g in 0..gene
  w_sum = Array.new(20)
  v_sum = Array.new(20)

  #評価--0ならナップサックに入れる、1なら入れない
  for i in 0..19
    w_sum[i] = 0
    v_sum[i] = 0
    for j in 0..49
      if ele[i][j]==0
        w_sum[i] += weight[j]
        v_sum[i] += value[j]
      end
    end
    #最大容量500を超えるなら価値は0
    if w_sum[i]>500
      v_sum[i] = 0
    end
  end

  #総価値を出力
  puts v_sum

  #次の世代の配列を生成
  nextele = Array.new(20)
  for i in 0..19
    nextele[i] = Array.new(50)
    for j in 0..49
      nextele[i][j] = ele [i][j]
    end
  end

  #選択--ルーレット選択
  f = Array.new(20)
  for i in 0..19
    f[i] = v_sum[i] / v_sum.inject{|sum, n| sum + n}.to_f
    if i > 0
      f[i] += f[i-1]
    end
  end
  for i in 0..19
  ruret = rand()
    for k in 0..19
      if ruret < f[k]
        nextele[i][j] = ele[k][j]
      end
    end
  end

 #トーナメント選択
  for i in 0..19
    select3 = Array.new(3)
    for k in 0..2
      select3[k] = rand(20)
    end
    if f[select3[0]] < f[select3[1]]
      nextele[i][j] = ele[select3[1]][j]
      if f[select3[1]] < f[select3[2]]
        nextele[i][j] = ele[select3[2]][j]
      end
    else
      nextele[i][j] = ele[select3[0]][j]
      if f[select3[0]] < f[select3[2]]
        nextele[i][j] = ele[select3[2]][j]
      end
    end
  end

  #選択--エリート戦略
  top2 = Array.new(2)
  number = Array.new(2)#top2の順番を数える配列
  if v_sum[0] > v_sum[1]
    top2[0] = v_sum[0]
    top2[1] = v_sum[1]
    number[0] = 0
    number[1] = 1
    else
    top2[0] = v_sum[1]
    top2[1] = v_sum[0]
    number[0] = 1
    number[1] = 0
  end

  for i in 2..19
    if v_sum[i] > top2[0]
      top2[1]=top2[0]
      top2[0]=v_sum[i]
      number[0]=i
      number[1]=0
    elsif v_sum[i] > top2[1]
      top2[1] = v_sum[i]
      number[1] = i
    end
  end

  #エリート戦略で選ばれた個体をelite配列に確保
  elite = Array.new(2)
  for i in 0..1
    elite[i]=Array.new(50)
    for j in 0..50
      elite[i][j]=ele[number[i]][j]
    end
  end

  if g == gene-1
    break
  end

  #一様交叉
  10.times do
    sele1 = rand(19)
    sele2 = rand(19)
    child = Array.new(2)
    child[0] = Array.new(50)
    child[1] = Array.new(50)
    mask = Array.new(50)
    for j in 0..49
      mask[j]= rand(2)
    end
    for j in 0..49
      if mask[j] == 0
        child[0][j]=ele[sele1][j]
        child[1][j]=ele[sele2][j]
      elsif mask[j] == 1
        child[0][j]=ele[sele2][j]
        child[1][j]=ele[sele1][j]
      end
    end
    for j in 0..49
      nextele[sele1][j]=child[0][j]
      nextele[sele2][j]=child[1][j]
    end
  end



  #突然変異
  for i in 0..19
    rate = rand()*100
    if rate < 3
      m = rand(20)
      nextele[i][m] = (nextele[i][m]+1)%2
    end
  end


  #次の世代に代入
  for i in 0..19
    for j in 0..50
      if i==0||i==1
        ele[i][j]=elite[i][j]
      else
        ele[i][j]=nextele[i][j]
      end
    end
  end
end


