import pickle


with open('decision-tree-model.pkl', 'rb') as f:
    data = pickle.load(f)

print(data)