module RankHelper
  
  def male_title( rank )
    gendered_rank_label = rank.male_gendered_label
    if gendered_rank_label
      link_to( gendered_rank_label.label, rank_show_url( :gendered_rank_label => gendered_rank_label ) )
    else
      '-'
    end
  end
  
  def female_title( rank )
    gendered_rank_label = rank.female_gendered_label
    if gendered_rank_label
      link_to( gendered_rank_label.label, rank_show_url( :gendered_rank_label => gendered_rank_label ) )
    else
      '-'
    end
  end
end
