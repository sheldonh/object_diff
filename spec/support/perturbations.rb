module Perturbations

  def making_a_change_to_hash(object)
    if object.include?(:perturbation)
      object.delete :perturbation
    else
      object.store :perturbation, :perturbed
    end
  end

end
